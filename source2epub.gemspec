# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "source2epub/version"
Gem::Specification.new do |spec|
  spec.name          = "source2epub"
  spec.version       = Source2Epub::VERSION
  spec.authors       = ["Burin Choomnuan"]
  spec.email         = ["agilecreativity@gmail.com"]
  spec.summary       = %q(Export any project from git repository or local directory to a single epub file)
  spec.description   = %q{Export any project from git repository or local directory to a single epub file.
                          Combine useful features of the following ruby gems
                          (vim_printer, eeepub and others)
                          to produce a single epub file that can be view by any device where epub is supported.
                         }
  spec.homepage      = "https://github.com/agilecreativity/source2epub"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 1.9.3'
  spec.files         = Dir.glob("{bin,lib}/**/*") + %w[Gemfile
                                                       Rakefile
                                                       source2epub.gemspec
                                                       README.md
                                                       CHANGELOG.md
                                                       LICENSE
                                                       .rubocop.yml
                                                       .gitignore]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_runtime_dependency "git", "~> 1.2"

  spec.add_runtime_dependency "agile_utils", "~> 0.3"
  spec.add_runtime_dependency "code_lister", "~> 0.2"
  spec.add_runtime_dependency "vim_printer", "~> 0.2"

  # NOTE: this is the custom version of the gem, as the official version 0.8.1
  # contain bugs in the zip library
  spec.add_runtime_dependency "eeepub_ext", "~> 0.8.3"

  spec.add_development_dependency "awesome_print", "~> 1.6"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "guard", "~> 2.13"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-spec-context", "~> 0.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rubocop", "~> 0.53"
  spec.add_development_dependency "yard", "~> 0.9"
end
