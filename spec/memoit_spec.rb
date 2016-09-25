require "memoit"
require "support/shared_examples/memoizer"

describe Memoit do
  context "with method prefix notation" do
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

    it_behaves_like "memoizer"

    it "returns the name of the method" do
      name = nil
      Class.new do
        name = memoize def blah; end
      end
      expect(name).to eq(:blah)
    end
  end

  context "with standalone notation" do
    let(:klass) do
      Class.new do
        def self.foo
          rand
        end
        memoize_class_method :foo

        def foo
          rand
        end
        memoize :foo

        def bar(*values)
          rand
        end
        memoize :bar

        def falsy
          foo
          false
        end
        memoize :falsy

        def query?
          rand
        end
        memoize :query?

        def bang!
          rand
        end
        memoize :bang!

        def ☃
          rand
        end
        memoize :☃
      end
    end

    it_behaves_like "memoizer"

    it "returns the name of the method" do
      name = nil
      Class.new do
        def blah; end
        name = memoize :blah
      end
      expect(name).to eq(:blah)
    end
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
