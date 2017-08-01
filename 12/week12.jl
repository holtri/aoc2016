struct Command{A<:Union{Int64, Char}, B<:Union{Int64, Char}}
  command::String
  arg1::A
  arg2::B
end

function parseInput(filename)
  input = readlines(open(filename))
  commands = Vector{Command}()

  for line in input
    l = split(line)
    if isa(parse(l[2]), Number)
        arg1 = parse(Int64, l[2])
        type1 = Int64
    else
      arg1 = l[2][1]
      type1 = Char
    end
    arg2 = 0
    type2 = Int64
    if length(l) > 2
      if isa(parse(l[3]), Number)
          arg2 = parse(Int64, l[3])
          type2 = Int64
      else
        arg2 = l[3][1]
        type2 = Char
      end
    end
    push!(commands, Command{type1,type2}(l[1],arg1,arg2))
  end
  return commands
end

function solve(input::Vector{Command})
  i::Int64 = 1
  register::Vector{Int64} = fill(0, 4)
  register[3] = 1

  counter = 1
  while i <= length(input)
    counter +=1
    # counter % 10000 == 0 &&  println("counter: $counter i: $i c: $(input[i])")

    if input[i].command == "inc"
      register[Int64(input[i].arg1) - 96] += 1
    elseif input[i].command == "dec"
      register[Int64(input[i].arg1) - 96] -= 1
    elseif input[i].command == "cpy"
        v = isa(input[i].arg1, Number) ? input[i].arg1 : register[Int64(input[i].arg1) - 96]
        register[Int64(input[i].arg2) - 96] = v
    else
       if isa(input[i].arg1, Number) ? input[i].arg1 != 0 : register[Int64(input[i].arg1) - 96] != 0
         i += isa(input[i].arg2, Number) ? input[i].arg2 : register[Int64(input[i].arg2) - 96]
         continue
       end
    end
    i+=1
  end
  register
end

input = parseInput("input.txt")
@time solve(input)
