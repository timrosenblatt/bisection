class Walker
  def initialize(pack)
    @pack = pack
  end

  def walk_dogs
    puts "good dogs :)"
  end

  attr_reader :pack
end
