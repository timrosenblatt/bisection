require './requires'

class Walker
  def initialize(pack)
    @pack = pack
  end

  def walk_dogs
    @pack.map &:walk
  end

  attr_reader :pack
end
