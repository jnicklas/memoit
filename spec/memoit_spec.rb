require "memoit"

describe Memoit do
  let(:klass) do
    Class.new do
      memoize_class_method def self.foo
        rand
      end

      memoize def foo
        rand
      end

      memoize def bar(*values)
        rand
      end

      memoize def falsy
        foo
        false
      end
    end
  end
  let(:instance) { klass.new }

  describe ".memoize" do
    it "caches result" do
      expect(instance.foo).to eq(instance.foo)
    end

    it "caches results for different parameters" do
      a = Object.new
      expect(instance.bar(1)).to eq(instance.bar(1))
      expect(instance.bar(2)).to eq(instance.bar(2))
      expect(instance.bar(a, 1, :foo, "bar")).to eq(instance.bar(a, 1, :foo, "bar"))
      expect(instance.bar(2)).not_to eq(instance.bar(1))
      expect(instance.bar(a, 1, :foo, "bar")).not_to eq(instance.bar(Object.new, 1, :foo, "bar"))
    end

    it "ignores cache when block given" do
      expect(instance.foo { }).not_to eq(instance.foo { })
    end

    it "caches falsy values" do
      expect(instance).to receive(:foo).once
      expect(instance.falsy).to eq(instance.falsy)
    end

    it "returns the name of the method" do
      name = nil
      Class.new do
        name = memoize def blah
        end
      end
      expect(name).to eq(:blah)
    end
  end

  describe ".memoize_class_method" do
    it "caches result" do
      expect(klass.foo).to eq(klass.foo)
    end
  end
end
