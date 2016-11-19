require './requires'

class Lala < Dog
  WALKING_ENERGY = 4

  def walk
    super

    :trot
  end
end
