# -*- encoding: utf-8 -*-
# stub: aws-sdk 1.41.0 ruby lib

Gem::Specification.new do |s|
  s.name = "aws-sdk"
  s.version = "1.41.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Amazon Web Services"]
  s.date = "2014-05-22"
  s.description = "AWS SDK for Ruby"
  s.executables = ["aws-rb"]
  s.files = ["bin/aws-rb"]
  s.homepage = "http://aws.amazon.com/sdkforruby"
  s.licenses = ["Apache 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "AWS SDK for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.4"])
      s.add_runtime_dependency(%q<json>, ["~> 1.4"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.4.4"])
      s.add_dependency(%q<json>, ["~> 1.4"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.4.4"])
    s.add_dependency(%q<json>, ["~> 1.4"])
  end
end
