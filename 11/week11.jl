using Base.Test
using IterTools

function isSafe(floor::Array{<:Integer,1})
  chipRTGpairs = reshape(floor, 2,5)
  activeRTG = [sum(chipRTGpairs[:,l]) == 2 for l in indices(chipRTGpairs,2)]
  singleChip = [chipRTGpairs[1,l] == 0 && chipRTGpairs[2,l] == 1 for l in indices(chipRTGpairs,2)]
  safe = !(any(activeRTG) && any(singleChip))
  return safe
end

@testset "isSafe Tests" begin
         @test !isSafe([1,1,0,0,1,1,0,0,0,1])
         @test isSafe([1,1,0,0,1,1,0,0,1,0])
         @test isSafe([1,1,0,0,1,1,0,0,1,1])
         @test isSafe([0,0,0,0,0,0,0,0,0,0])
         @test isSafe([1,0,1,0,0,0,0,0,0,0])
         @test isSafe([1,1,1,0,0,0,0,0,0,0])
         @test !isSafe([1,1,0,1,0,0,0,0,0,0])
end

function moveElevator(state, rowIndexA, rowIndexB, colIndices)
  tmp = copy(state)
  tmp[rowIndexA, colIndices] = state[rowIndexB, colIndices]
  tmp[rowIndexB, colIndices] = state[rowIndexA, colIndices]
  tmp
end

@testset "moveElevator test" begin
teststate = [0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 1 0 0 0 0;
         0 0 0 0 1 0 1 1 1 1;
         1 1 1 1 0 0 0 0 0 0]
  @test begin
           before = teststate
           after = moveElevator(teststate, 3, 4, [1,2])
           after = moveElevator(after, 3, 4, [1,2])
           before == after
  end
  @test begin
           after = moveElevator(teststate, 3, 4, [9,10])
           after[3,9] == 0 && after[3,10] == 0 && after[4,9] == 1 & after[4,10] == 1
  end
  @test begin
         before = teststate
         moveElevator(teststate, 3, 4, [9,10])
         before == teststate
  end
end

function adjacentFloors(x)
         x == 1 && return [2]
         (x == 2 || x == 3) && return [x-1, x+1]
         x == 4 && return [3]
end

macro pretty(m)
  :(for row in indices($m, 1)
    println(reduce((x,y) -> "$x $y", "",  $m[row, :]))
  end)
end

state = [0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 1 0 0 0 0;
         0 0 0 0 1 0 1 1 1 1;
         1 1 1 1 0 0 0 0 0 0]

searchFront = [(4, state)]
nextLevelCandidates = []

steps = 0
while steps < 2
  for state in searchFront
    elevatorPositon = state[1]
    materialPositions = state[2]
    # candidate = Matrix(0,0) # have to declare this, otherwise the macro can't find it in scope
    for c in subsets(1:10,2) # all possible actions
      if sum(materialPositions[elevatorPosition, c] ) > 0 # at least one part must be moved
        for ap in adjacentFloors(elevatorPosition)
          candidate = moveElevator(materialPositions, elevatorPosition, ap, c)
          println(ap)
          push!(nextLevelCandidates, (ap, candidate))
        end
      end
    end
  end
  searchFront = nextLevelCandidates
  steps += 1
end


# candidate = moveElevator(state, elevatorPosition, 3, [1,2])
@pretty candidate
