include("./circular_list.jl")
using Base.Test
using circ_list

@test begin
  tmp = CircularList{Int}()
  isempty(tmp)
end

@test begin
  tmp = CircularList{Int}()
  push!(tmp, 1)
  head(tmp).value == 1
  push!(tmp, 2)
  head(tmp).value == 2
  head(tmp).next.value == 1
end

@test begin
  tmp = CircularList{Int}()
  push!(tmp, 1)
  push!(tmp, 2)
  head(tmp).value == 2
  head(tmp).next.value == 1
  head(tmp).next.next.value == 2
end
