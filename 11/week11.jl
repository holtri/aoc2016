using Base.Test
using IterTools

function isSafe(floor::Array{<:Integer,1})
  chipRTGpairs = reshape(floor, 2,5)
  activeRTG = [sum(chipRTGpairs[:,l]) == 2 for l in indices(chipRTGpairs,2)]
  singleChip = [chipRTGpairs[1,l] == 0 && chipRTGpairs[2,l] == 1 for l in indices(chipRTGpairs,2)]
  safe = !(any(activeRTG) && any(singleChip))
  return safe
end

function isSafe(state::Matrix)
  for row in indices(state,1)
    !isSafe(state[row, :]) && return false
  end
  return true
end

@testset "isSafe Tests" begin
         @testset "single floor" begin
           @test !isSafe([1,1,0,0,1,1,0,0,0,1])
           @test isSafe([1,1,0,0,1,1,0,0,1,0])
           @test isSafe([1,1,0,0,1,1,0,0,1,1])
           @test isSafe([0,0,0,0,0,0,0,0,0,0])
           @test isSafe([1,0,1,0,0,0,0,0,0,0])
           @test isSafe([1,1,1,0,0,0,0,0,0,0])
           @test !isSafe([1,1,0,1,0,0,0,0,0,0])
         end
         @testset "state" begin
          @test begin
            teststate = [0 0 0 0 0 0 0 0 0 0;
                    0 0 0 0 0 1 0 0 0 0;
                    0 0 0 0 1 0 1 1 1 1;
                    1 1 1 1 0 0 0 0 0 0]
            isSafe(teststate)
          end
          @test begin
            teststate = [0 0 0 0 0 0 0 0 0 0;
                    1 1 0 0 0 1 0 0 0 0;
                    0 0 0 0 1 0 1 1 1 1;
                    0 0 1 1 0 0 0 0 0 0]
            !isSafe(teststate)
          end
       end
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

function swapPairs(state, pairA, pairB)
  tmp = copy(state)
  tmp[:, pairB] = state[:, pairA]
  tmp[:, pairA] = state[:, pairB]
  tmp
end

@testset "swap test" begin
  teststate = [0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 1 0 0 0 0;
          0 0 0 0 1 0 1 1 1 1;
          1 1 1 1 0 0 0 0 0 0]
  @test begin
    expected = [0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 1 0 0 0 0;
            1 1 0 0 1 0 1 1 0 0;
            0 0 1 1 0 0 0 0 1 1]
    actual = swapPairs(teststate, [1,2], [9,10])
    actual == expected
  end
  @test begin
    expected = copy(teststate)
    swapPairs(teststate, [1,2], [9,10])
    expected == teststate
  end
end

function addVisited!(visitedStates, elevatorPosition, state)
  for c in subsets([1,3,5,7,9], 2)
      push!(visitedStates, hash((elevatorPosition, swapPairs(state, [c[1], c[1]+1], [c[2], c[2]+1]))))
  end
end

function solve()
  initialMaterialPositions = [0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 1 0 0 0 0;
           0 0 0 0 1 0 1 1 1 1;
           1 1 1 1 0 0 0 0 0 0]

  searchFront = [(4, initialMaterialPositions)]
  nextLevelCandidates = []
  visitedStates = Set()
  steps = 1
  solution = false
  maxSoFar = 0
  while steps < 40 && !solution
    j = 0

    for state in searchFront
      j % 1000 == 0 && println("j: $j")
      j+=1
      elevatorPosition = state[1]
      materialPositions = state[2]
      candidate = Matrix(0,0)
      for c in subsets(1:10,2) # all possible actions
        if sum(materialPositions[elevatorPosition, c] ) > 0 # at least one part must be moved
          for ap in adjacentFloors(elevatorPosition)
            candidate = moveElevator(materialPositions, elevatorPosition, ap, c)
            !in(hash((ap, candidate)), visitedStates) && isSafe(candidate) && (push!(nextLevelCandidates, (ap, candidate)); addVisited!(visitedStates, ap, candidate))
            sum(candidate[1, :]) == 10 && (println("Solution Found!"); solution = true)
            sum(candidate[1, :]) > maxSoFar && (maxSoFar = sum(candidate[1, :]); println("up at highest floor: $(sum(candidate[1, :]))"))
          end
        end
      end
    end
    searchFront = nextLevelCandidates
    println("Search Front Size = $(length(searchFront))")
    nextLevelCandidates = []
    steps += 1
  end
end

solve()
# candidate = moveElevator(state, elevatorPosition, 3, [1,2])
