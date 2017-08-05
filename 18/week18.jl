input = readlines(open(joinpath(@__DIR__, "input.txt")))
# input[1] = ".^^.^.^^^^"

function nextRow(currentRow)
  nextRow = copy(currentRow)
  for i in 2:length(nextRow)-1
    nextRow[i] = xor(currentRow[i-1], currentRow[i+1])
  end
  nextRow
end

function numberOfSafeTiles(firstrow, maxrows)
  current = BitVector(vcat(false, [x == '^' for x in firstrow], false))
  steps = 1
  numberSafeTiles = 0
  while steps <= maxrows
    numberSafeTiles += length(current) - sum(current) - 2
    # println(join([x == true ? '^' : '.' for x in current][2:end-1]))
    current = nextRow(current)
    steps += 1
  end
  numberSafeTiles
end

@time numberOfSafeTiles(input[1], 400000)
