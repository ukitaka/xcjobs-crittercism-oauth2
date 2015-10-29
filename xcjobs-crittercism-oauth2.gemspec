# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcjobs/crittercism/oauth2/version'

Gem::Specification.new do |spec|
  spec.name          = "xcjobs-crittercism-oauth2"
  spec.version       = Xcjobs::Crittercism::Oauth2::VERSION
  spec.authors       = ["ukitaka"]
  spec.email         = ["yuki.takahashi.1126@gmail.com"]

  spec.summary       = %q{crittercism plugin for xcjobs}
  spec.description   = %q{
    Crittercism plugin for xcjobs.
    You can upload dSYM using new api.
    If you use Xcode7, `/api_beta/dsym/` doesn't work.
    
    xcjobs: 
        https://github.com/kishikawakatsumi/xcjobs
  }
  spec.homepage      = "https://github.com/ukitaka/xcjobs-crittercism-oauth2"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "xcjobs", "~> 0.1"
end
