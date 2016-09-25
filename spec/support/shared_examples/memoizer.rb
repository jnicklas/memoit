shared_examples "memoizer" do
  context "when memoizing a class method" do
    it "caches result" do
      expect(klass.foo).to eq(klass.foo)
    end
  end

  context "when memoizing an instance method" do
    let(:instance) { klass.new }

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
  end
end
