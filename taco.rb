require './requires'

class Taco < Dog
  def initialize
    @appetite = 100
  end

  def walk
    :fast
  end

  def eat
    @appetite = 0
  end

  def full?
    @appetite == 0
  end
end
