require_relative "lib/trailblazer/errors/version"

Gem::Specification.new do |spec|
  spec.name          = "trailblazer-errors"
  spec.version       = Trailblazer::Errors::VERSION
  spec.authors       = ["Nick Sutterer"]
  spec.email         = ["apotonick@gmail.com"]

  spec.summary       = "Generic errors object to be used in operations and contracts."
  spec.homepage      = "https://trailblazer.to"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")
  spec.license       = "LGPL-3.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trailblazer/trailblazer-errors"
  spec.metadata["changelog_uri"] = "https://github.com/trailblazer/trailblazer-errors/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest-line"
  spec.add_development_dependency "dry-validation" # DISCUSS: do we want this hard-coded in all tests?
end
