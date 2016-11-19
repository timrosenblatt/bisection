require './requires'

pack = Set.new

pack << Taco.new
pack << Sneakers.new
pack << Shaggy.new
pack << Lala.new

clyde = Walker.new pack

clyde.walk_dogs
