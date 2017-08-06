input = 3001330

function solve(input::Int)
  elves = [(x,1) for x in 1:input]
  i=1
  while i < length(elves)
    push!(elves, (elves[i][1], elves[i][2] + elves[i+1][2]))
    i +=2
  end
  elves[end]
end

solve(input)


function opposite(x::Int, len)
  tmp = (x + convert(Int, floor(len/2))) % (len)
  tmp > 0 ? tmp : len
end

function solve2(input)
  i = 1
  elves = [(x,1) for x in 1:input]
  while length(elves) > 1
    stealfrom = opposite(i, length(elves))
    # println("$(elves[i][1]) steals from $(elves[stealfrom][1])")
    elves[i] = (elves[i][1], elves[i][2] + elves[stealfrom][2])
    deleteat!(elves, stealfrom)
    i += 1
    i > length(elves) && (i=1)
    length(elves) % 1000 == 0 && println(length(elves))
  end
  elves[1]
end

solve2(input)
