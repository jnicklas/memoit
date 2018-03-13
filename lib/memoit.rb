require "memoit/version"

module Memoit
  def self.extended(klass)
    unless klass.singleton_class?
      klass.singleton_class.extend(self)
    end
  end

  # Memoize the method with the given name.
  #
  # @example
  #   class Foo
  #     memoize def bar(value)
  #       expensive_calculation(value)
  #     end
  #   end
  def memoize(name)
    ivar_method_name = name.to_s.sub("?", "__questionmark").sub("!", "__bang")
    ivar_name = "@_memo_#{ivar_method_name}".to_sym
    mod = Module.new do
      define_method(name) do |*args, &block|
        return super(*args, &block) if block
        cache = instance_variable_get(ivar_name) || instance_variable_set(ivar_name, {})
        cache.fetch(args.hash) { |hash| cache[hash] = super(*args) }
      end
    end
    prepend mod
    name
  end

  # Memoize the class method with the given name.
  #
  # @example
  #   class Foo
  #     memoize_class_method def self.bar(value)
  #       expensive_calculation(value)
  #     end
  #   end
  def memoize_class_method(name)
    singleton_class.memoize(name)
  end
end
