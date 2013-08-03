$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cz_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cz_auth"
  s.version     = CzAuth::VERSION
  s.authors     = ["Mike Kelley"]
  s.email       = ["mike@codezombie.org"]
  s.summary     = "A Simple has_secure_password implementation"
  s.description = "A Simple has_secure_password implementation"

  s.files = Dir["{app,config,db,lib,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails",                           "~> 4.0.0"
  s.add_dependency "bcrypt-ruby",                     "~> 3.0.0"
end
