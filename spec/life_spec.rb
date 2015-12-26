require 'life'

RSpec.describe Cell, "#alive?" do
  context "initial state" do
    it "is false" do
      cell = Cell.new
      expect(cell.alive?).to be_falsey
    end
  end

  context "when alive" do
    it "is true" do
      cell = Cell.new(true)
      expect(cell.alive?).to be_truthy
    end
  end
end

RSpec.describe Cell, "#regenerate" do
  context "when dead" do
    it "returns a dead cell" do
      cell = Cell.new(false)
      expect(cell.regenerate([]).alive?).to be_falsey
    end
  end

  context "when dead with 3 live neighbors" do
    it "returns a live cell" do
      n1   = Cell.new(true)
      n2   = Cell.new(true)
      n3   = Cell.new(true)
      cell = Cell.new(false)
      expect(cell.regenerate([n1, n2, n3]).alive?).to be_truthy
    end
  end

  context "when alive with fewer than 2 live neighbors" do
    it "returns a dead cell" do
      n1   = Cell.new(false)
      n2   = Cell.new(false)
      n3   = Cell.new(false)
      cell = Cell.new(false)
      expect(cell.regenerate([n1, n2, n3]).alive?).to be_falsey
    end
  end

  context "when alive with two live neighbors" do
    it "returns a live cell" do
      n1   = Cell.new(true)
      n2   = Cell.new(true)
      n3   = Cell.new(false)
      cell = Cell.new(true)
      expect(cell.regenerate([n1, n2, n3]).alive?).to be_truthy
    end
  end

  context "when alive with three live neighbors" do
    it "returns a live cell" do
      n1   = Cell.new(true)
      n2   = Cell.new(true)
      n3   = Cell.new(true)
      cell = Cell.new(true)
      expect(cell.regenerate([n1, n2, n3]).alive?).to be_truthy
    end
  end

  context "when alive with more than three live neighbors" do
    it "returns a dead cell" do
      n1   = Cell.new(true)
      n2   = Cell.new(true)
      n3   = Cell.new(true)
      n4   = Cell.new(true)
      cell = Cell.new(true)
      expect(cell.regenerate([n1, n2, n3, n4]).alive?).to be_falsey
    end
  end
end

RSpec.describe Universe, "#regenerate" do
  context "with 1 cell" do
    it "regenerates all cells" do
      c11 = double(Cell)
      expect(c11).to receive(:regenerate)

      Universe.new([[c11]]).regenerate
    end
  end

  context "with 9 cells" do
    it "regenerates all cells" do
      c11 = instance_double(Cell, "c11")
      c12 = instance_double(Cell, "c12")
      c13 = instance_double(Cell, "c13")
      c21 = instance_double(Cell, "c21")
      c22 = instance_double(Cell, "c22")
      c23 = instance_double(Cell, "c23", :regenerate => nil)
      c31 = instance_double(Cell, "c31", :regenerate => nil)
      c32 = instance_double(Cell, "c32", :regenerate => nil)
      c33 = instance_double(Cell, "c33", :regenerate => nil)
      expect(c11).to receive(:regenerate).with([c12, c21, c22])
      expect(c12).to receive(:regenerate).with([c11, c13, c21, c22, c23])
      expect(c13).to receive(:regenerate).with([c12, c22, c23])
      expect(c21).to receive(:regenerate).with([c11, c12, c22, c31, c32])
      expect(c22).to receive(:regenerate).with([c11, c12, c13, c21, c23, c31, c32, c33])

      Universe.new([[c11, c12, c13],[c21, c22, c23], [c31, c32, c33]]).regenerate
    end

    it "returns a new universe" do
      c11 = double(Cell)
      c12 = double(Cell)
      c21 = double(Cell)
      c22 = double(Cell)

      universe = Universe.new([[
        instance_double(Cell, :regenerate => c11),
        instance_double(Cell, :regenerate => c12)
      ],[
        instance_double(Cell, :regenerate => c21),
        instance_double(Cell, :regenerate => c22)
      ]]).regenerate

      expect(universe).to eq(Universe.new([[c11, c12],[c21, c22]]))
    end
  end
end

RSpec.describe(Life, "#run") do
  it "regenerates the universe" do
    gen2 = instance_double(Universe, "gen 2")
    gen1 = instance_double(Universe, "gen 1", :regenerate => gen2)
    expect(gen2).to receive(:regenerate).and_return(gen2)

    life = Life.new(gen1, instance_double("Interface", :update => nil))
    life.run
  end

  it "updates the interface" do
    gen2 = instance_double(Universe, "gen 2")
    allow(gen2).to receive(:regenerate).and_return(gen2)
    gen1 = instance_double(Universe, "gen 1", :regenerate => gen2)
    interface = instance_double("Interface", :update => nil)
    expect(interface).to receive(:update).with(gen1)
    expect(interface).to receive(:update).with(gen2)
    life = Life.new(gen1, interface)
    life.run
  end

  it "stops when consequtive universes are equal" do
    universe = double(Universe)
    allow(universe).to receive(:regenerate).and_return(universe)

    life = Life.new(universe, instance_double("Interface", :update => nil))
    life.run
  end
end
