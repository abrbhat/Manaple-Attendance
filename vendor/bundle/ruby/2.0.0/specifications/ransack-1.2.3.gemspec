# -*- encoding: utf-8 -*-
# stub: ransack 1.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "ransack"
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ernie Miller", "Ryan Bigg"]
  s.date = "2014-04-30"
  s.description = "Ransack is the successor to the MetaSearch gem. It improves and expands upon MetaSearch's functionality, but does not have a 100%-compatible API."
  s.email = ["ernie@erniemiller.org", "radarlistener@gmail.com"]
  s.homepage = "https://github.com/activerecord-hackery/ransack"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "ransack"
  s.rubygems_version = "2.1.11"
  s.summary = "Object-based searching for ActiveRecord (currently)."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<polyamorous>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<machinist>, ["~> 1.0.6"])
      s.add_development_dependency(%q<faker>, ["~> 0.9.5"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_development_dependency(%q<pg>, ["= 0.17.0"])
      s.add_development_dependency(%q<mysql2>, ["= 0.3.14"])
      s.add_development_dependency(%q<pry>, ["= 0.9.12.2"])
    else
      s.add_dependency(%q<actionpack>, [">= 3.0"])
      s.add_dependency(%q<activerecord>, [">= 3.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<polyamorous>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<machinist>, ["~> 1.0.6"])
      s.add_dependency(%q<faker>, ["~> 0.9.5"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_dependency(%q<pg>, ["= 0.17.0"])
      s.add_dependency(%q<mysql2>, ["= 0.3.14"])
      s.add_dependency(%q<pry>, ["= 0.9.12.2"])
    end
  else
    s.add_dependency(%q<actionpack>, [">= 3.0"])
    s.add_dependency(%q<activerecord>, [">= 3.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<polyamorous>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<machinist>, ["~> 1.0.6"])
    s.add_dependency(%q<faker>, ["~> 0.9.5"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
    s.add_dependency(%q<pg>, ["= 0.17.0"])
    s.add_dependency(%q<mysql2>, ["= 0.3.14"])
    s.add_dependency(%q<pry>, ["= 0.9.12.2"])
  end
end
