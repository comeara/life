require_relative "cell"
require_relative "universe"
require_relative "console_interface"
require_relative "gosu_interface"
require_relative "seeds"

class Life
  def initialize(universe, interface)
    @universe  = universe
    @interface = interface
  end

  def run(tick = 0.5)
    curr_generation = @universe
    loop do
      @interface.update(curr_generation)
      prev_generation = curr_generation
      curr_generation = curr_generation.regenerate
      break if curr_generation == prev_generation
      sleep tick
    end
  end
end
