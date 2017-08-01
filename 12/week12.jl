input = readlines(open("input.txt"))

function solve(input)
  i=1
  register = fill(0, 4)
  # register[3] = 1
  counter = 1
  while i <= length(input)
    counter +=1
    # counter % 10000 == 0 && println("counter: $counter i: $i c: $(input[i])")
    c = split(input[i])

    if c[1] == "inc"
      register[Int(c[2][1])-96] +=1
    elseif c[1] == "dec"
      register[Int(c[2][1])-96] -=1
    elseif c[1] == "cpy"
        v = isa(parse(c[2]), Number) ? parse(Int, c[2]) : register[Int(c[2][1]) - 96]
        register[Int(c[3][1]) - 96] = v
    else
       if isa(parse(c[2]), Number) ? parse(Int, c[2]) != 0 : register[Int(c[2][1]) - 96] != 0
         i += isa(parse(c[3]), Number) ? parse(Int, c[3]) : register[Int(c[3][1]) - 96]
         continue
       end
    end
    i+=1
  end
  register
end

@time solve(input)
