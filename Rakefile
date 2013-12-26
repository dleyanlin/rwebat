require 'rake'
require 'rake/testtask'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'fileutils'
include FileUtils
require 'rubygems'

spec = Gem::Specification.new do |s|
  s.name =%q{rwebta}
  s.version = "1.8.2"
  s.summary = "A TA framework for web application"
  s.description = "Executable automation accept testing for web applications"
  s.platform = Gem::Platform::RUBY
  s.author = "drewz"
  s.email   = ""
  s.autorequire = 'rwebta'
  s.executables = ['rwebta']
  s.default_executable = 'rwebta'
  s.post_install_message = %{
    (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
         Thank you for installing rwebta for your web automation testing
    (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::) (::)
   }
   
  s.add_dependency("watir", "> 1.7.1")
  #s.add_dependency("firewatir", "> 1.7.1")
  s.add_dependency("watir-webdriver", "> 0.3.2")
    
  s.add_dependency("commonwatir", "> 1.7.1")

  s.add_dependency("rspec", ">= 2.5.0")
  s.add_dependency("cucumber", "> 0.9.4")
  s.add_dependency("win32console", ">= 1.2.0")
  

  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  
  s.files = %w(COPYING LICENSE README Rakefile) +
    Dir.glob("lib/**/*") +
	Dir.glob("test/**/*") +
    Dir.glob("examples/**/*") +
    Dir.glob("bin/**/*") +
    Dir.glob("{app_generators,cucumber_generators}/**/*")
	
  s.require_path = "lib"
  # s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true if RUBY_PLATFORM !~ /mswin/
end

task :install => [:test, :package] do
  sh %{sudo gem install #{name}-#{version}.gem}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{name}}
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.add ['README', 'LICENSE', 'COPYING', 'lib/**/*.rb', 'doc/**/*.rdoc']
end

task :default => [:test, :package]

CLEAN.include ['build/*', '**/*.o', '**/*.so', '**/*.a', 'lib/*-*', '**/*.log', 'pkg', 'lib/*.bundle', '*.gem', '.config']

