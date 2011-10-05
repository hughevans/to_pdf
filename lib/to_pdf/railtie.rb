module ToPDF
  class Railtie < Rails::Railtie
    config.to_pdf_renderer = :princexml

    initializer 'to_pdf.configure' do |app|
      if app.config.respond_to? :to_pdf_asset_domain
        PrinceXML.asset_domain   = app.config.to_pdf_asset_domain
        Wkhtmltopdf.asset_domain = app.config.to_pdf_asset_domain
      end
    
      if app.config.respond_to? :prince_xml_executable_path
        PrinceXML.executable_path = app.config.prince_xml_executable_path
      end
    
      if app.config.respond_to? :wkhtmltopdf_executable_path
        Wkhtmltopdf.executable_path = app.to_pdf.wkhtmltopdf_executable_path
      end
    end

    initializer 'to_pdf.init_mime_types' do
      Mime::Type.register 'application/pdf', :pdf
    end

    initializer 'to_pdf.insert_into_action_controller' do |app|
      ActiveSupport.on_load :action_controller  do
        ActionController::Renderers.add :pdf do |template, options|
          string = render_to_string template, options
          if app.config.to_pdf_renderer == :wkhtmltopdf
            send_data Wkhtmltopdf.string_to_pdf(string), :type => :pdf, :disposition => 'inline'
          else
            send_data PrinceXML.string_to_pdf(string), :type => :pdf, :disposition => 'inline'
          end
        end

        class ActionController::Responder
          def to_pdf
            controller.render :pdf => controller.action_name
          end
        end
      end
    end
  end
end
