module ToPDF
  class Railtie < Rails::Railtie
    initializer 'to_pdf.configure_prince_xml' do |app|
      if app.config.respond_to? :prince_xml_asset_domain
        PrinceXML.asset_domain = app.config.prince_xml_asset_domain
      end

      if app.config.respond_to? :prince_xml_executable_path
        PrinceXML.executable_path = app.config.prince_xml_executable_path
      end
    end

    initializer 'to_pdf.init_mime_types' do
      Mime::Type.register 'application/pdf', :pdf
    end

    initializer 'to_pdf.insert_into_action_controller' do
      ActiveSupport.on_load :action_controller  do
        ActionController::Renderers.add :pdf do |template, options|
          string = render_to_string template, options
          send_data PrinceXML.string_to_pdf(string), :type => :pdf, :disposition => 'inline'
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
