require_relative '../lib/monkey_patcher'

class Foo
  def bar; 'original Foo#bar'; end
end

class Foo
  include MonkeyPatcher
  monkey_trace("Reopening Foo to add a couple methods necessary for the README",
                File.expand_path(__FILE__))
  
  def self.bar; 'class method bar'; end
  def bar; 'modified Foo#bar'; end
  def baz; 'added Foo#baz'; end
end

class Foo
  include MonkeyPatcher
  monkey_trace("Just to show it works",
                File.expand_path(__FILE__))
  def bar; 'patched another time'; end
end

puts "Foo was tempered" if Foo.monkey_patched?
puts Foo.patched_methods