class Cell
  def initialize(alive = false)
    @alive     = alive
  end

  def alive?
    !!@alive
  end

  def dead?
    !alive?
  end

  def regenerate(neighbors)
    live_neighbor_count = live_neighbor_count(neighbors)
    if alive? && (live_neighbor_count == 2 || live_neighbor_count == 3)
      Cell.new(true)
    elsif dead? && live_neighbor_count == 3
      Cell.new(true)
    else
      Cell.new(false)
    end
  end

  def ==(other)
    other.is_a?(Cell) && (alive? == other.alive?)
  end

  private

  def live_neighbor_count(neighbors)
    neighbors.select { |n| n.alive? }.count
  end
end
