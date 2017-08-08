macro readinput(x)
  :(readlines(open(joinpath(@__DIR__, $x))))
end

input = map(x -> parse.(Int, split(x, "-")), @readinput "input.txt")

inInterval(x::Int, interval::Vector{Int}) = x >= interval[1] && x <= interval[2]

function inAnyInterval(x, intervals)
  for interval in intervals
    inInterval(x, interval) && return true
  end
  return false
end

function solve()
  value = 1
  intervals = sort(input, lt = (x,y)-> x[1] < y[1])
  while value < 4294967295
    !inAnyInterval(value, intervals) && break
    value+=1
  end
  value
end
@time solve()

function solve2()
  intervals = sort(input, lt = (x,y)-> x[1] < y[1])
  value = 0
  i = 0
  while i <= 4294967295
    if inInterval(i,intervals[1])
      # println("interval: $(intervals[1])")
      i = intervals[1][2] + 1
      intervals = [x for x in intervals if x[2] > intervals[1][2]]
    else
      value +=1
      i +=1
    end
  end
  value
end
@time solve2()
