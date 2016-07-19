# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "abaci/version"

Gem::Specification.new do |s|
  s.name          = "abaci"
  s.version       = Abaci::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["John Tornow"]
  s.email         = ["john@johntornow.com"]
  s.homepage      = "http://github.com/jdtornow/abaci"
  s.summary       = "A basic stats reporting and collection tool for Ruby."
  s.description   = %Q{Collect stats on events, activities and behaviors across time in Ruby with a Redis backend.}
  s.files         = Dir.glob("{lib,vendor}/**/*") + %w(README.md CHANGELOG.md)
  s.require_paths = ["lib"]

  s.add_dependency "redis", ">= 2.0"

  s.required_ruby_version = ">= 2.2.2"
end
