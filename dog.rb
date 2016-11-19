require './requires'

class Dog
  FULL_STOMACH = 0
  EMPTY_STOMACH = 100

  def initialize
    @appetite = EMPTY_STOMACH
  end

  def walk
    @appetite += WALKING_ENERGY

    :generic_walk
  end

  def eat
    @appetite = FULL_STOMACH
  end

  def full?
    @appetite == FULL_STOMACH
  end
end
