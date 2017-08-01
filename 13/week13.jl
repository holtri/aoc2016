using DataStructures
using IterTools
const input = 1358

function isWall(x::Int,y::Int)
 checksum = x^2 + 3x + 2x * y + y + y^2 + input
 isodd(counter([i for i in bits(checksum)])['1'])
end

visited = Set{Tuple{Int, Int}}()
searchfront = Vector{Tuple{Int, Int}}()
candidates = Vector{Tuple{Int, Int}}()

location = (1,1)
push!(searchfront, location)
steps = 0

# while location != (31,39)
while steps < 50
 location = pop!(searchfront)
 neighbors = [map(+, i, location) for i in [(0,1), (0,-1), (1,0), (-1,0)]]
 neighbors = filter(x -> !isWall(x...) && all(x.>=0) && !(x in visited), neighbors)
 if length(neighbors) > 0
  push!(candidates, neighbors...)
  push!(visited, neighbors...)
 end

 if length(searchfront) == 0
  searchfront = candidates
  candidates = Vector{Tuple{Int, Int}}()
  steps +=1
 end
end

# println("Task 1: shortest path: $steps")
println("Task 2: possible locations: $(length(visited))")
