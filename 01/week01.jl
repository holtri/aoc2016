input = readcsv("input.txt")

function rotate(x, direction)
  if direction == "R"
    return mod(x+1, 4)
  else
    return mod(x-1, 4)
  end
end

state = 1; x = 0; y=0
visitedLocations = Set()
intersections = []

for c in input
  direction = strip(c)[1:1]
  steps = parse(Int, strip(c)[2:end])
  state = rotate(state, direction)
for i in 1:steps
    if state == 1
      y += 1
    elseif state == 2
      x += 1
    elseif state == 3
      y -= 1
    else
      x -= 1
    end
    [x y] in visitedLocations && push!(intersections, [x y])
    push!(visitedLocations, [x y])
  end
  visitedVertices = cat(1, visitedVertices, [x,y]')
end

println("Task1: Distance to (0,0) is $(abs(x) + abs(y))")
println("Task2: First already visited Location: $(intersections[1]) with distance $(abs(intersections[1][1]) + abs(intersections[1][2]))")
