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

      memoize def single_param(object)
        object
      end

      memoize def bar(*values)
        rand
      end

      memoize def baz(pos = nil, hash = {}, kwak: nil)
        rand
      end

      memoize def qux(pos = nil, kwak: nil)
        rand
      end

      memoize def quux(kwak: nil)
        rand
      end

      memoize def corge(hash = {}, kwak: nil)
        rand
      end

      memoize def falsy
        foo
        false
      end

      memoize def query?
        rand
      end

      memoize def bang!
        rand
      end

      memoize def ☃
        rand
      end
    end
  end
  let(:instance) { klass.new }

  describe ".memoize" do
    it "caches result" do
      expect(instance.foo).to eq(instance.foo)
    end

    it "does not convert objects to a hash implicitly" do
      object = double(to_hash: {})

      expect(instance.single_param(object)).to eq(object)
    end

    it "caches results for different parameters" do
      a = Object.new
      expect(instance.bar(1)).to eq(instance.bar(1))
      expect(instance.bar(2)).to eq(instance.bar(2))
      expect(instance.bar(a, 1, :foo, "bar")).to eq(instance.bar(a, 1, :foo, "bar"))
      expect(instance.bar(2)).not_to eq(instance.bar(1))
      expect(instance.bar(a, 1, :foo, "bar")).not_to eq(instance.bar(Object.new, 1, :foo, "bar"))
    end

    it "caches results when positional, hash and keyword arguments are used" do
      a = Object.new
      expect(instance.baz(a, { hash_key: "hash_value" }, kwak: "kwav")).to eq(instance.baz(a, { hash_key: "hash_value" }, kwak: "kwav"))
    end

    it "caches results when positional and keyword arguments are used" do
      a = Object.new
      expect(instance.qux(a, kwak: "kwav")).to eq(instance.qux(a, kwak: "kwav"))
    end

    it "caches results when keyword arguments are used" do
      expect(instance.quux(kwak: "kwav")).to eq(instance.quux(kwak: "kwav"))
    end

    it "ignores cache if keyword arguments differ" do
      expect(instance.quux(kwak: "1")).not_to eq(instance.quux(kwak: "2"))
    end

    it "caches results when hash and keyword arguments are used" do
      expect(instance.corge({ hash_key: "hash_value" }, kwak: "kwav")).to eq(instance.corge({ hash_key: "hash_value" }, kwak: "kwav"))
    end

    it "ignores cache when block given" do
      expect(instance.foo { }).not_to eq(instance.foo { })
    end

    it "caches falsy values" do
      expect(instance).to receive(:foo).once
      expect(instance.falsy).to eq(instance.falsy)
    end

    it "handles question-mark methods" do
      expect(instance.query?).to eq(instance.query?)
    end

    it "handles bang methods" do
      expect(instance.bang!).to eq(instance.bang!)
    end

    it "handles non-ASCII-name methods" do
      expect(instance.☃).to eq(instance.☃)
    end

    it "returns the name of the method" do
      name = nil
      Class.new do
        name = memoize def blah
        end
      end
      expect(name).to eq(:blah)
    end

    it "works in a mixin" do
      mod = Module.new do
        memoize def cname
          self.class.name
        end
      end

      Foo = Class.new do
        include mod
      end

      Bar = Class.new do
        include mod
      end

      expect(Foo.new.cname).to eq("Foo")
      expect(Bar.new.cname).to eq("Bar")
    end
  end

  describe ".memoize_class_method" do
    it "caches result" do
      expect(klass.foo).to eq(klass.foo)
    end
  end
end
