require './requires'

class Sneakers < Dog
  WALKING_ENERGY = 7

  def walk
    super

    :bouncy
  end
end
