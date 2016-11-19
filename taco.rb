require './requires'

class Taco < Dog
  WALKING_ENERGY = 35

  def walk
    super

    :fast
  end
end
