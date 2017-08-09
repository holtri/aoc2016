input = readlines(open(joinpath(@__DIR__, "input.txt")))

struct Server
 size::Int
 used::Int
 avail::Int
end

grid = Matrix{Server}(35,25)

for x in input
 m = match(r".*x(?<x>\d*)-y(?<y>\d*) *(?<size>\d*)T *(?<used>\d*)T *(?<avail>\d*)T *(?<usep>\d*)", x)
 coord = (parse(Int, m[:x]) + 1, parse(Int, m[:y]) + 1)
 grid[coord...] = Server(parse(Int, m[:size]), parse(Int, m[:used]), parse(Int, m[:avail]))
end

# Task1
count = 0
for i in eachindex(grid)
 grid[i].used == 0 && continue
  for j in eachindex(grid)
    i == j && continue
    grid[i].used <= grid[j].avail && (count += 1)
  end
end
count

# Some fun with indexing

function isneighbor(I1::CartesianIndex, I2::CartesianIndex)
 length(I1) == length(I2) || throw(BoundsError())
 I1 == I2 && return false # only true neighbor
 delta = I1 - I2
 s = 0
 for i in 1:length(delta)
  s += abs(delta[i])
  s > 1 && return false
 end
 true
end

R = CartesianRange(size(grid))
idxstart, idxend = first(R), last(R)

count = 0
for idx in R
 grid[idx].used == 0 && continue
 neighboridx = [c for c in CartesianRange(max(idxstart, idx - idxstart), min(idxend, idxend + idxstart)) if isneighbor(idx, c)]
 for subR in neighboridx
   grid[subR].avail >= grid[idx].used && (count += 1)
 end
end
