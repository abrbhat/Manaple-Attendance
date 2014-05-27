# -*- encoding: utf-8 -*-
# stub: formtastic 2.3.0.rc3 ruby lib

Gem::Specification.new do |s|
  s.name = "formtastic"
  s.version = "2.3.0.rc3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin French"]
  s.date = "2014-04-12"
  s.description = "A Rails form builder plugin/gem with semantically rich and accessible markup"
  s.email = ["justin@indent.com.au"]
  s.extra_rdoc_files = ["README.textile"]
  s.files = ["README.textile"]
  s.homepage = "http://github.com/justinfrench/formtastic"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "A Rails form builder plugin/gem with semantically rich and accessible markup"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0"])
      s.add_development_dependency(%q<nokogiri>, ["< 1.6.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.14.0"])
      s.add_development_dependency(%q<rspec_tag_matchers>, [">= 1.0.0"])
      s.add_development_dependency(%q<hpricot>, ["~> 0.8.3"])
      s.add_development_dependency(%q<BlueCloth>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.6"])
      s.add_development_dependency(%q<colored>, [">= 0"])
      s.add_development_dependency(%q<tzinfo>, [">= 0"])
      s.add_development_dependency(%q<ammeter>, ["= 0.2.5"])
      s.add_development_dependency(%q<appraisal>, ["= 1.0.0.beta3"])
      s.add_development_dependency(%q<rake>, ["<= 10.1.1"])
      s.add_development_dependency(%q<activemodel>, [">= 0"])
    else
      s.add_dependency(%q<actionpack>, [">= 3.0"])
      s.add_dependency(%q<nokogiri>, ["< 1.6.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.14.0"])
      s.add_dependency(%q<rspec_tag_matchers>, [">= 1.0.0"])
      s.add_dependency(%q<hpricot>, ["~> 0.8.3"])
      s.add_dependency(%q<BlueCloth>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.6"])
      s.add_dependency(%q<colored>, [">= 0"])
      s.add_dependency(%q<tzinfo>, [">= 0"])
      s.add_dependency(%q<ammeter>, ["= 0.2.5"])
      s.add_dependency(%q<appraisal>, ["= 1.0.0.beta3"])
      s.add_dependency(%q<rake>, ["<= 10.1.1"])
      s.add_dependency(%q<activemodel>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 3.0"])
    s.add_dependency(%q<nokogiri>, ["< 1.6.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.14.0"])
    s.add_dependency(%q<rspec_tag_matchers>, [">= 1.0.0"])
    s.add_dependency(%q<hpricot>, ["~> 0.8.3"])
    s.add_dependency(%q<BlueCloth>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.6"])
    s.add_dependency(%q<colored>, [">= 0"])
    s.add_dependency(%q<tzinfo>, [">= 0"])
    s.add_dependency(%q<ammeter>, ["= 0.2.5"])
    s.add_dependency(%q<appraisal>, ["= 1.0.0.beta3"])
    s.add_dependency(%q<rake>, ["<= 10.1.1"])
    s.add_dependency(%q<activemodel>, [">= 0"])
  end
end
