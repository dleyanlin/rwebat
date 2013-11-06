require 'rubygems'
require 'rubigen'
require 'rbconfig'

class RwebtaGenerator < RubiGen::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :author => nil,
                  :shebang => DEFAULT_SHEBANG,
                  :an_option => 'some_default'

  attr_reader :app_name#, :site, :driver

  # so we can use the site generator
  #prepend_sources(RubiGen::GemPathSource.new([:rwebta]))

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
	@app_name = File.basename(File.expand_path(@destination_root))
    #@name = base_name
    #extract_options
  end

  def manifest
    record do |m|          
      @@new_directories.each { |path| m.directory path }
	  m.directory "pages"
	  m.directory "step_Definitions"
	  m.directory "test_data"
	  m.directory "test_result"
	  m.directory "script"
	  #m.file_copy_each ["generate","generate.cmd"], "script"
	  m.file_copy_each ["console", "console.cmd"], "script", :collision => :force 
      m.dependency "install_rubigen_scripts", [destination_root, 'feature'],
        :shebang => options[:shebang], :collision => :ask
    end
  end

  @@new_directories =
    %w(
      pages
      step_Definitions
      test_data
      test_result
    )  
  
  protected
    def banner
      <<-EOS
      Create a project via #{File.basename $0} to get start test script.
      Usage: #{File.basename $0} app name [options]"
      EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator "#{File.basename $0} options:"
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

end
