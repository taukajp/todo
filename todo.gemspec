# frozen_string_literal: true

require_relative "lib/todo/version"

Gem::Specification.new do |spec|
  spec.name = "todo"
  spec.version = Todo::VERSION
  spec.authors = ["Taukajp"]
  spec.email = ["taukajp@icloud.com"]

  spec.summary = "Todo Task management tool."
  spec.description = "Todo Task management tool."
  spec.homepage = "https://github.com/taukajp/todo"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/taukajp/todo"
  spec.metadata["changelog_uri"] = "https://github.com/taukajp/todo"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_runtime_dependency "activerecord", "~> 7.0"
  spec.add_runtime_dependency "puma", "~> 6.0"
  spec.add_runtime_dependency "rack-flash3", "~> 1.0"
  spec.add_runtime_dependency "sinatra", "~> 3.0"
  spec.add_runtime_dependency "sinatra-contrib", "~> 3.0"
  spec.add_runtime_dependency "sqlite3", "~> 1.6"
  spec.add_runtime_dependency "thor", "~> 1.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
