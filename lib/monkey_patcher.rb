class Object
  def self.monkey_patched?
    self.respond_to?(:patched_methods) && !patched_methods.empty?
  end
end

module MonkeyPatcher
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  class AppendedMethodInfo
    attr_accessor :name, :desc, :origin
    def to_s
      "#{name} - patched in #{origin || 'an untraced file'} - #{desc}"
    end
  end
  
  module ClassMethods
    def monkey_trace(desc, file_path=nil)
      @desc = desc
      @current_monkey_patch_file = file_path
    end
    
    def patched_methods
      @patched_methods || []
    end
    
    def method_added(method_name)
      log_monkey_patch(method_name)
      # call super in case someone else is hooking into the method addition
      super
    end
    
    def singleton_method_added(method_name)
      log_monkey_patch(method_name, true)
      # call super in case someone else is hooking into the method addition
      super
    end
    
    private
    
    def log_monkey_patch(method_name, klass_meth=false)
      a_meth        = AppendedMethodInfo.new
      a_meth.name   = klass_meth ? "#{name}.#{method_name}" : method_name
      a_meth.origin = @current_monkey_patch_file
      a_meth.desc   = @desc
      
      @patched_methods ||= []
      @patched_methods << a_meth
    end
  end
  
end