require_relative 'lib/with_tax/version'

Gem::Specification.new do |spec|
  spec.name          = "with_tax"
  spec.version       = WithTax::VERSION
  spec.authors       = ["ken1flan"]
  spec.email         = ["ken1flan@gmail.com"]

  spec.summary       = %q{Allows you to calculate sales tax without defining a method in a class.}
  spec.homepage      = "https://github.com/ken1flan/with_tax"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ken1flan/with_tax"
  spec.metadata["changelog_uri"] = "https://github.com/ken1flan/with_tax/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
