
require 'rake'
require 'rake/testtask'
require 'rake/clean'
require 'rubygems/package_task'
require 'rdoc/task'
require 'fileutils'
include FileUtils
require 'rubygems'
require File.dirname(__FILE__) + '/lib/rwebat/version'

spec = Gem::Specification.new do |s|
  s.name = "rwebat"
  s.version = Rwebat::VERSION
  s.summary = "A Acceptance testing framework for web application and window applications"
  s.description = "Executable Acceptance testing for web applications"
  s.platform = Gem::Platform::RUBY
  s.author = "PSOQA"
  s.email   = "pso-qa@hz.webex.com"
  s.autorequire = "rwebat"
  s.executables = ["rwebat"]
  s.default_executable = "rwebat"
  s.post_install_message = %{
    (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
         Thank you for installing rwebat for your web automation testing
    (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
   }
  
  #s.add_dependency("watir", "> 1.7.1")
  #s.add_dependency("firewatir", "> 1.7.1")
  s.add_dependency("watir-webdriver", ">= 0.3.2")
    
  #s.add_dependency("commonwatir", "> 1.7.1")

  #s.add_dependency("rspec", ">= 2.5.0")
  s.add_dependency("cucumber", "> 0.9.4")
  #s.add_dependency("win32console", ">= 1.2.0")
  s.add_dependency("faker", "> 1.0")
  s.add_dependency("activerecord", "> 3.0")
  s.add_dependency("rautomation", "> 0.7.2")
  s.add_dependency("win32screenshot", ">= 1.0.7")
  s.add_dependency("log4r", ">= 1.1.10")
  

  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  
  s.files = %w(COPYING LICENSE README Rakefile) +
    Dir.glob("{bin,doc/rdoc,test,lib}/**/*") + 
    Dir.glob("ext/**/*.{h,c,rb}") +
    Dir.glob("examples/**/*") +
    Dir.glob("tools/*.rb") +
    Dir.glob("resources/**/*") +
    Dir.glob("{app_generators,cucumber_generators}/**/*")
	
  s.require_path = "lib"
  s.bindir = "bin"
end