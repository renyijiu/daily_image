
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "daily_image/version"

Gem::Specification.new do |spec|
  spec.name          = "daily_image"
  spec.version       = DailyImage::VERSION
  spec.authors       = ["renyijiu"]
  spec.email         = ["lanyuejin1108@gmail.com"]

  spec.summary       = %q{A gem generate a daily image. Just For Fun 😊}
  spec.description   = %q{A gem generate a daily image. Just For Fun 😊}
  spec.homepage      = "https://github.com/renyijiu/daily_image"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby-vips", "~> 2.0.13"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
