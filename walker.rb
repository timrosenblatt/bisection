require './requires'

class Walker
  def initialize(pack)
    @pack = pack
  end

  attr_reader :pack

  def walk_dogs
    @pack.map &:walk
  end
end
