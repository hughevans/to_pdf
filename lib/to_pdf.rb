autoload :PrinceXML, 'to_pdf/prince_xml'
autoload :Wkhtmltopdf, 'to_pdf/wkhtmltopdf'

require 'to_pdf/railtie' if defined?(Rails::Railtie)
