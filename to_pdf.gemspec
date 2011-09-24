# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'to_pdf/version'

Gem::Specification.new do |s|
  s.name              = 'to_pdf'
  s.version           = ToPDF::VERSION
  s.authors           = ['Hugh Evans']
  s.email             = 'hugh@artpop.com.au'
  s.homepage          = 'https://github.com/hughevans/to_pdf'
  s.summary           = %q{Render rails actions as a PDF using PrinceXML.}
  s.description       = %q{Render rails actions as a PDF using PrinceXML.}

  s.rubyforge_project = 'to_pdf'

  s.files             = `git ls-files`.split("\n")
  s.require_path      = 'lib'

  s.add_dependency 'rails', '>= 3.0.0'
  s.add_development_dependency 'rspec', '~> 2.6.0'
end
