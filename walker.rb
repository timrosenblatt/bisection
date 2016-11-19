require './requires'

class Walker
  def initialize(pack)
    @pack = pack
  end

  attr_reader :pack

  def walk_dogs
    begin
      @pack.map &:walk
    rescue ArgumentError => e
      if e.message =~ /eat/
        feed_dogs
        retry
      end

      raise
    end
  end

  def feed_dogs
    @pack.map(&:eat).all?
  end
end
