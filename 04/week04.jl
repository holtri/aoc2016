input = readlines(open("input.txt"))

rotateChar(x,len) = 'a' + mod(len + x - 'a', Int('z') - Int('a') + 1)

function solve(input, rotate)
  idSum = 0
  for line in input
    m = match(r"(?<name>([a-z]|-)*)(?<id>\d+)(?<checksum>(\[[a-z]*\]))", line)

    name = replace(m[:name], r"-", s"")
    checksum = replace(m[:checksum], r"\[|\]", s"")
    id = parse(Int, m[:id])

    if rotate
      name = map(x -> rotateChar(x, id), name)
      ismatch(r".*north.*", name) && println(name * " id= $id")
    end

    wordcount = Dict{Char, Int}()
    for c in name
      wordcount[c] = get(wordcount, c, 0) +1
    end

    sortedwc = sort(collect(wordcount), lt = (x,y) -> begin
      if x[2] == y[2]
        x[1] < y[1]
      else
        x[2] > y[2]
      end
    end)

    if convert(String,[x[1] for x in sortedwc])[1:5] == checksum
      idSum += id
    end
  end
  idSum
end


println("Task1: sum of ids = $(solve(input, false))")
println("Task2: sum of ids = $(solve(input, true))")
