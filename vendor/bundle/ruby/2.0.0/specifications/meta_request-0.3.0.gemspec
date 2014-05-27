# -*- encoding: utf-8 -*-
# stub: meta_request 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "meta_request"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dejan Simic"]
  s.date = "2014-04-16"
  s.description = "Request your request"
  s.email = ["desimic@gmail.com"]
  s.homepage = "https://github.com/dejan/rails_panel/tree/master/meta_request"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "Supporting gem for Rails Panel (Google Chrome extension for Rails development)"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 0"])
      s.add_runtime_dependency(%q<rack-contrib>, [">= 0"])
      s.add_runtime_dependency(%q<callsite>, [">= 0"])
    else
      s.add_dependency(%q<railties>, [">= 0"])
      s.add_dependency(%q<rack-contrib>, [">= 0"])
      s.add_dependency(%q<callsite>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 0"])
    s.add_dependency(%q<rack-contrib>, [">= 0"])
    s.add_dependency(%q<callsite>, [">= 0"])
  end
end
