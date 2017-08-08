using Combinatorics

input = readlines(open(joinpath(@__DIR__, "input.txt")))

function scramble(pw, command)
  if command[1] == "swap"
    if command[2] == "letter"
      i = find(x -> x == command[3], pw)[1]
      j = find(x -> x == command[6], pw)[1]
    else
      i = parse(Int, command[3]) + 1
      j = parse(Int, command[6]) + 1
    end
    tmp = pw[i]
    pw[i] = pw[j]
    pw[j] = tmp
  elseif command[1] == "rotate"
    if command[2] == "left" || command[2] == "right"
      steps = parse(Int, command[3])
      command[2] == "left" && (steps = -steps)
      pw = circshift(pw, steps)
    else
      steps = find(x -> x == command[7], pw)[1] - 1 # 0 index
      steps = steps >= 4 ? steps + 1 : steps
      steps = steps + 1
      pw = circshift(pw, steps)
    end
  elseif command[1] == "reverse"
    from = parse(Int, command[3]) +1
    to = parse(Int, command[5]) +1
    reverse!(pw, from, to)
  else
    del = parse(Int, command[3]) + 1
    ins = parse(Int, command[6]) + 1
    tmp = pw[del]
    deleteat!(pw, del)
    insert!(pw, ins, tmp)
  end
  pw
end

function solve(pw, input)
  for i in 1:length(input)
    pw = scramble(pw, split(input[i], " "))
  end
  join(pw)
end

# Task 1
solve(split("abcdefgh",""), input)

# Task 2
for i in 1:factorial(8)
  solve(nthperm(split("abcdefgh",""),i), input) == "fbgdceah" && (println(join(nthperm(split("abcdefgh",""),i))); break)
end
