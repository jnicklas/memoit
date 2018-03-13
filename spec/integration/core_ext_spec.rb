describe Memoit, "as core extension" do
  before :all do
    require "memoit/core_ext"
  end

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
        extend Memoit

        name = memoize def blah
        end
      end
      expect(name).to eq(:blah)
    end

    it "works in a mixin" do
      module Test
        Mod = Module.new do
          extend Memoit

          memoize def cname
            self.class.name
          end
        end

        Foo = Class.new do
          include Mod
        end

        Bar = Class.new do
          include Mod
        end
      end

      expect(Test::Foo.new.cname).to eq("Test::Foo")
      expect(Test::Bar.new.cname).to eq("Test::Bar")
    end
  end

  describe ".memoize_class_method" do
    it "caches result" do
      expect(klass.foo).to eq(klass.foo)
    end
  end
end
