using Devectorize

input = "10111011111001111"
# fillLength = 272
fileLength = 35651584
bitinput = BitArray([parse(Int8, c) for c in input])

extendString(x::BitArray) = vcat(x, BitArray([0]), flipbits!(reverse(x)))

function extendString(x::BitArray, minLength)
  length(x) > minLength && return x[1:minLength]
  extendString(extendString(x), minLength)
end

function getchecksum(x)
  a = reshape(x, 2, :)
  @devec result = a[1,:] .== a[2,:];
  return result
end

function solve(bitinput::BitArray, fileLength::Int)
  initialFill = extendString(bitinput, fileLength)
  checksum = getchecksum(initialFill)
  while iseven(length(checksum))
    checksum = getchecksum(checksum)
  end
  checksum
end

@time solve(bitinput, fileLength)

println(reduce(*, string.(convert.(Int8, solve(bitinput, fileLength)))))
