require './requires'

class Dog
  FULL_STOMACH = 0
  EMPTY_STOMACH = 100

  def initialize
    @appetite = EMPTY_STOMACH
  end

  def walk
    if hungry?
      raise ArgumentError, 'Needs to eat'
    end

    @appetite += self.class::WALKING_ENERGY

    :generic_walk
  end

  def eat
    @appetite = FULL_STOMACH

    true
  end

  def full?
    @appetite == FULL_STOMACH
  end

  def hungry?
    @appetite > EMPTY_STOMACH
  end
end
