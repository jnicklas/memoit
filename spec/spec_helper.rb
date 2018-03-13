module TestNamespace
  def remove_constants
    constants.each do |name|
      remove_const(name)
    end
  end
end

RSpec.configure do |config|
  # Require memoit before each example group, and then undefine it (and allow it
  # to be later re-required) afterwards. This allows us to test both explicit
  # and core-ext (monkey-patched) usage
  config.before :all do
    @prev_loaded_features = $LOADED_FEATURES.dup
    require "memoit"
  end

  config.after :all do
    Object.send(:remove_const, :Memoit)

    ($LOADED_FEATURES - @prev_loaded_features).each do |file|
      $LOADED_FEATURES.delete(file)
    end
  end

  # Create a `Test` module whose constants are cleared after each example
  config.before :each do
    Object.const_set(:Test, Module.new { |m| m.extend(TestNamespace) })
  end

  config.after :each do
    Object.send(:remove_const, :Test)
  end
end
