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


# random deletion is too slow...
function poptest(x)
  tmp = ones(Int, x)
  for i in 1:x
    pop!(tmp)
  end


  function shifttest(x)
    tmp = ones(Int, x)
    for i in 1:x
      shift!(tmp)
    end
  end

function deletetest(x)
  tmp = ones(Int, x)
  for i in 1:x
    deleteat!(tmp,rand(1:length(tmp)))
  end
end

@time poptest(10^8)
@time shifttest(10^8)
@time poptest(10^5)
@time deletetest(10^5)

solve2(input)

function solve2fast(input::Int)
  split = convert(Int, floor(input/2))
  elvesgain = [(x,1) for x in 1:split]
  elvesgive = [(x,1) for x in split+1:input]

split = isodd(length(elvesgain))? length(elvesgain)/2:  length(elvesgain)/2 +1
  while length(elvesgive) != 0
    println(split)
    nextgain = Vector{Tuple{Int,Int}}()
    nextgive = Vector{Tuple{Int,Int}}()

    # split = convert(Int, floor(length(elvesgive)/2))
    if length(elvesgive) > length(elvesgain)
      push!(nextgain, pop!(elvesgive))
    end

    numelements = length(elvesgain)
    for i in 1:numelements
      tmp = shift!(elvesgain)
      if i < split
        push!(nextgain, (tmp[1], tmp[2] + shift!(elvesgive)[2]) )
      else
        push!(nextgive, (tmp[1], tmp[2] + shift!(elvesgive)[2]) )
      end
    end
    elvesgain = nextgain
    elvesgive = nextgive
    split = isodd(length(elvesgain))? length(elvesgain)/2:  length(elvesgain)/2 +1
    println("nextgain: $nextgain")
  end
  elvesgain
end

solve2fast(4)[1]
