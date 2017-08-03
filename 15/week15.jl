
function solve()
  # discs = [1,0,2,0,0,5]
  # numberPositions = [17, 7, 19, 5, 3, 13]
  discs = [1,0,2,0,0,5,0]
  numberPositions = [17, 7, 19, 5, 3, 13, 11]

  i = 0
  while true
    all( ( (discs + range(1,length(discs))) .% numberPositions) .== 0) && return i
    discs = (discs + 1) .% numberPositions
    i += 1
  end
end
println("$(solve())")
