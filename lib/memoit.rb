require "memoit/version"

module Memoit

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
      define_method(name) do |*args, **kwargs, &block|
        return super(*args, **kwargs, &block) if block
        cache = instance_variable_get(ivar_name) || instance_variable_set(ivar_name, {})
        cache.fetch(args.hash) { |hash| cache[hash] = super(*args, **kwargs) }
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

Module.send(:include, Memoit)
