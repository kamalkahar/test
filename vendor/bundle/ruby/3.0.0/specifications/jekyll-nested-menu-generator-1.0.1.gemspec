# -*- encoding: utf-8 -*-
# stub: jekyll-nested-menu-generator 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-nested-menu-generator".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Granicus".freeze]
  s.date = "2020-08-27"
  s.description = "Provides a tag that generates a nested navigation menu for\n                     a specified folder. Useful for automatically generating\n                     a multilevel menu that mirrors your directory structure,\n                     or generating a menu of generated pages.".freeze
  s.email = "support@granicus.com".freeze
  s.homepage = "https://github.com/granicus/jekyll-nested-menu-generator".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "Tag for generating a nested navigation menu.".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<jekyll>.freeze, [">= 3.0"])
  else
    s.add_dependency(%q<jekyll>.freeze, [">= 3.0"])
  end
end
