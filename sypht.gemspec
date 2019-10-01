
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sypht/version"

Gem::Specification.new do |spec|
  spec.name          = "sypht"
  spec.version       = Sypht::VERSION
  spec.authors       = ["Ankur Singh"]
  spec.email         = ["ankur13019@iiitd.ac.in"]

  spec.summary       = "Ruby reference sypht implementation for working with the Sypht API"
  spec.description   = "Sypht(https://sypht.com) is a SaaS API((https://docs.sypht.com/) which extracts key fields from documents. For example, you can upload an image or pdf of a bill or invoice and extract the amount due, due date, invoice number and biller information."
  spec.homepage      = "https://github.com/sypht-team/sypht-ruby-sypht"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "coveralls", "~> 0.8.23"

  spec.add_runtime_dependency 'rest-client', '~> 2.1'
end
