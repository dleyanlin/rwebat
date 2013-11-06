require 'rbconfig'

class FeatureGenerator < RubiGen::Base
  attr_reader :plural_name, :singular_name, :class_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name          = args.shift
    @plural_name   = @name.pluralize.underscore
    @singular_name = @name.singularize.underscore
    @class_name    = @name.singularize.classify
  end

  def manifest
    record do |m|
     #m.directory 'features/steps'
      m.template  'feature.erb', "manage_#{plural_name}.feature"
      m.template  'steps.erb', "step_Definitions/#{singular_name}_steps.rb"
    end
  end

protected

  def banner
    "Usage: #{$0} feature ModelName [feature1] [feature2]"
  end

end
