require "gosu"

class GosuInterface < Gosu::Window
  WIDTH = HEIGHT = 640
  CAPTION = "Game of Life"

  class LifeAdapter
    attr_reader :generation

    def initialize(generation)
      @generation = generation
    end

    def update(generation)
      @generation = generation
    end
  end

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = CAPTION
  end

  def update
    # Game play is happening in another thread
  end

  def draw
    row_count = 0
    @life_adapter.generation.each_row do |row|
      col_count = 0
      row.each do |cell|
        draw_cell(cell, row_count, col_count)
        col_count += 1
      end
      row_count += 1
    end
  end

  def main(args)
    grid = Seeds::TOAD
    @pixels_per_cell = WIDTH / grid.size
    universe = Universe.new(grid)
    @life_adapter = LifeAdapter.new(universe)
    @life = Life.new(universe, @life_adapter)

    Thread.new { @life.run }

    show
  end

  private

  def draw_cell(cell, row_count, col_count)
    x_top  = col_count * @pixels_per_cell
    y_left = row_count * @pixels_per_cell
    color = cell.alive? ? Gosu::Color::BLACK : Gosu::Color::WHITE;
    width = height = @pixels_per_cell

    draw_quad(x_top, y_left, color,
              x_top+width, y_left, color,
              x_top, y_left+height, color,
              x_top+width, y_left+height, color
             )
  end
end
