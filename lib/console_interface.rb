class ConsoleInterface
  def initialize(out = $stdout)
    @out = out
  end

  def main(args)
    grid = Seeds::BLINKER

    Life.new(Universe.new(grid), self).run
  end

  def update(generation)
    generation.each_row do |row|
      row.each do |cell|
        @out << (cell.alive? ? "1" : "0")
      end
      @out << "\n"
    end
    @out << "\n" * 2
  end
end
