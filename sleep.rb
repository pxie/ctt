require "paint"

rand = Random.new
colors = [:red, :green, :cyan, :yellow, :blue]

10.times do
  c = colors.sample
  puts Paint[c.to_s, c]
  sleep(rand.rand * 3)
end

puts "end game"