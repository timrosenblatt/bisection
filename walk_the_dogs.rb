#!/usr/bin/env ruby

require './requires'

pack = Set.new

pack << Taco.new
pack << Sneakers.new
pack << Shaggy.new
pack << Lala.new

clyde = Walker.new pack

clyde.walk_dogs

puts 'All dogs walked!'

clyde.feed_dogs

puts 'All dogs fed'
