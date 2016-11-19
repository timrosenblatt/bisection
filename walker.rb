require './requires'

class Walker
  def initialize(pack)
    @pack = pack
  end

  attr_reader :pack

  def walk_dogs
    retries = 0

    begin
      @pack.map &:walk
    rescue ArgumentError => e
      if e.message =~ /eat/
        feed_dogs if any_hungry?

        retries += 1
        retry if retries < 5
      end

      raise
    end
  end

  def any_hungry?
    @pack.map(&:hungry?)
  end

  def feed_dogs
    @pack.map(&:eat).all?
  end
end
