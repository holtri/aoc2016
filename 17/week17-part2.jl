using Nettle

input = "pgflpeqp"
currentfront = Set{Tuple{Int,Int,String}}()
push!(currentfront, (1,1,input))

function combine(a::Tuple{Int,Int,String}, b::Tuple{Int,Int,String})
  return (a[1]+b[1], a[2] + b[2], a[3] * b[3])
end

paths = []
numberSteps = 0
while length(currentfront) > 0 #&& numberSteps < 400
  numberSteps += 1
  nextfront = Set{Tuple{Int,Int,String}}()
  for currentPosition in currentfront
    currentPosition[1] == 4 && currentPosition[2] == 4 && (push!(paths, currentPosition[3]); continue)
    opendoors = [x in ['b','c','d','e','f'] for x in hexdigest("md5", currentPosition[3])[1:4]]
    possiblesteps = [currentPosition[2] - 1 >= 1,
                     currentPosition[2] + 1 <= 4,
                     currentPosition[1] - 1 >= 1,
                     currentPosition[1] + 1 <= 4]

    nextsteps = [(0,-1,"U"),(0,1,"D"),(-1,0,"L"),(1,0,"R")][opendoors .& possiblesteps]

    map(x -> push!(nextfront, combine(currentPosition, x)), nextsteps)
  end
  currentfront = nextfront
  println(numberSteps)
end

println("Task 2: number of steps possible: $(length(paths[end]) - length(input))")
