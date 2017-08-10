using Base.Test

function neighborsum(grid::Array{T}) where T <:Number
 R = CartesianRange(size(grid))
 idxstart, idxend = first(R), last(R)
 totalsum::T = 0
 for idx in R
  for subR in CartesianRange(max(idxstart, idx - idxstart), min(idxend, idx + idxstart))
    idx == subR ? continue : (totalsum += grid[subR])
  end
 end
 totalsum
end

@testset "neighborsum" begin
 @test neighborsum(ones(Int, 1)) == 0
 @test neighborsum(ones(Int, 1, 1)) == 0
 @test neighborsum(zeros(Int, 2, 2)) == 0
 @test neighborsum(ones(Int, 1, 2)) == 2
 @test neighborsum(ones(Int, 2,2)) == 12
 @test neighborsum(ones(Int, 2,2,2)) == 56
 @test neighborsum(ones(Int, 3,3)) == 40
 @test neighborsum(ones(Int, 3,3,3)) == 316 # 3x3x3 is 8*7 + 12*11 + 6*17 + 26 = 316
end
