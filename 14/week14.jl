using Nettle

input = "abc"

function stretchHash(hash, count)
  count == 0 && return hash
  return stretchHash(hexdigest("md5", hash), count - 1)
end

function hashIndex(index, stretch)
  if stretch
    stretchHash(hexdigest("md5", input*string(index)), 2016)
  else
    hexdigest("md5", input*string(index))
  end
end

function pushHash!(tracker, index, stretch)
  challenge = hashIndex(index, stretch)
  m = match(r"(.)\1{4}", challenge)
  if !(m === Void())
    push!(tracker, m[:1])
  else
    push!(tracker, "")
  end
end

function solve(stretch)
  tracker = Vector{String}()
  output = Vector{String}()
  i = 0
  while i < 1000
    pushHash!(tracker, i, stretch)
    i += 1
  end

  j = 0
  while true && j < 100000
    j % 1000 == 0 && println(j)
    challenge = hashIndex(j, stretch)

    m = match(r"(.)\1{2}", challenge)
    !(m === Void()) && m[:1] in tracker && push!(output, m[:1])

    length(output) == 64 && break
    j += 1; i += 1
    shift!(tracker)
    pushHash!(tracker, i, stretch)
  end
  return j
end


println("Task 1: $(solve(false))")
println("Task 2: $(solve(true))")
