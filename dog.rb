require './requires'

class Dog
  def initialize
    @appetite = 100
  end

  def walk
    :generic_walk
  end

  def eat
    @appetite = 0
  end

  def full?
    @appetite == 0
  end
end
