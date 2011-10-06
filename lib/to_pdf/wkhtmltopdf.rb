class Wkhtmltopdf
  class << self
    attr_writer :executable_path, :asset_domain

    def asset_domain=(domain)
      @asset_domain = domain
    end

    def executable_path=(path)
      @executable_path = File.expand_path(path)
    end

    def detect_executable_path
      IO.popen('which wkhtmltopdf') { |pipe| @executable_path = pipe.gets }
      raise 'Cannot find command `wkhtmltopdf` in $PATH' unless @executable_path
      @executable_path.strip!
    end

    def string_to_pdf(string)
      detect_executable_path unless @executable_path

      header = extract_header_url(string)
      footer = extract_footer_url(string)

      pdf = IO.popen(wkhtmltopdf_command(header, footer), 'w+')
      pdf.puts(localise_paths(string))
      pdf.close_write
      result = pdf.gets(nil)
      pdf.close_read

      result
    end

    def wkhtmltopdf_command(header, footer)
      "#{@executable_path} -q --allow #{Rails.public_path}#{" --header-html '#{header}'" if header}#{" --footer-html '#{footer}'" if footer} - - "
    end

    def localise_paths(string)
      string.gsub!('src="/', "src=\"#{Rails.public_path}/") if defined?(Rails)

      if @asset_domain
        string.gsub!('link href="/', "link href=\"#{@asset_domain}/")
      elsif defined?(Rails)
        string.gsub!('link href="/', "link href=\"#{Rails.public_path}/")
        string.gsub!('url(/', "url(#{Rails.public_path}/")
      end

      string
    end

    def extract_header_url(string)
      header_url = nil
      string.scan(/<meta [^>]*>/).each { |meta| header_url = meta.scan(/content=["']([^"']*)/)[0][0] unless meta.scan(/name="header"/).empty?}
      header_url
    end

    def extract_footer_url(string)
      footer_url = nil
      string.scan(/<meta [^>]*>/).each { |meta| footer_url = meta.scan(/content=["']([^"']*)/)[0][0] unless meta.scan(/name="footer"/).empty?}
      footer_url
    end
  end
end
