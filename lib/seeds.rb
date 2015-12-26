class Seeds
  def self.build_blinker
    grid = Array.new(5) { Array.new(5) { Cell.new(false) }}
    grid[2][1] = Cell.new(true)
    grid[2][2] = Cell.new(true)
    grid[2][3] = Cell.new(true)
    grid
  end

  def self.build_toad
    grid = Array.new(6) { Array.new(6) { Cell.new(false) }}
    grid[2][2] = Cell.new(true)
    grid[2][3] = Cell.new(true)
    grid[2][4] = Cell.new(true)
    grid[3][1] = Cell.new(true)
    grid[3][2] = Cell.new(true)
    grid[3][3] = Cell.new(true)
    grid
  end

  BLINKER = build_blinker
  TOAD    = build_toad
end
