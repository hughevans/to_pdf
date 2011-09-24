class PrinceXML
  class << self
    attr_writer :executable_path, :asset_domain

    def asset_domain=(domain)
      @asset_domain = domain
    end

    def executable_path=(path)
      @executable_path = File.expand_path(path)
    end

    def detect_executable_path
      IO.popen('which prince') { |pipe| @executable_path = pipe.gets }
      raise 'Cannot find command `prince` in $PATH' unless @executable_path
      @executable_path.strip!
    end

    def string_to_pdf(string)
      detect_executable_path unless @executable_path

      pdf = IO.popen(prince_command, 'w+')
      pdf.puts(localise_paths(string))
      pdf.close_write
      result = pdf.gets(nil)
      pdf.close_read

      result
    end

    def prince_command
      "#{@executable_path} --input=html --silent - -o '-'"
    end

    def localise_paths(string)
      string.gsub!('src="/', "src=\"#{Rails.public_path}/")

      if @asset_domain
        string.gsub!('link href="/', "link href=\"#{@asset_domain}/")
      elsif defined?(Rails)
        string.gsub!('link href="/', "link href=\"#{Rails.public_path}/")
        string.gsub!('url(/', "url(#{Rails.public_path}/")
      end

      string
    end
  end
end
