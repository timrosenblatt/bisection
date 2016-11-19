require './requires'

class Taco < Dog
  WALKING_ENERGY = 35

  def walk
    super

    :fast
  end

  def hungry?
    true
  end
end
