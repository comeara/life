class Universe
  def initialize(grid)
    @grid = grid
    @max_row_index = @max_col_index = grid.size - 1
  end

  def regenerate
    grid = Array.new(@grid.size) { Array.new(@grid.size) }
    0.upto(@max_row_index) do |row_idx|
      0.upto(@max_col_index) do |col_idx|
        grid[row_idx][col_idx] = @grid[row_idx][col_idx].regenerate(neighbors(row_idx, col_idx))
      end
    end
    Universe.new(grid)
  end

  def ==(other)
    other.is_a?(Universe) && (@grid == other.send(:grid))
  end

  def each_row
    @grid.each { |row| yield row }
  end

  private

  attr_reader :grid

  def neighbors(row_idx, col_idx)
    row_range = ([0, row_idx - 1].max)..([@max_row_index, row_idx + 1].min)
    col_range = ([0, col_idx - 1].max)..([@max_col_index, col_idx + 1].min)

    neighbors = []
    row_range.each do |r|
      col_range.each do |c|
        neighbors << @grid[r][c] unless (r == row_idx && c == col_idx)
      end
    end
    neighbors
  end
end
