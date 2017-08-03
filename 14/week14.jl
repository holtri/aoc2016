using Nettle

input = "jlmsuwbz"

tracker = Vector{String}()
output = Vector{String}()

function pushHash!(tracker, index)
  challenge = hexdigest("md5", input*string(i))
  m = match(r"(.)\1{4}", challenge)
  if !(m === Void())
    push!(tracker, m[:1])
  else
    push!(tracker, "")
  end
end

i = 0
while i < 1001
  pushHash!(tracker, i)
  i += 1
end

println(i)
j = 0
while true && j < 50000
  challenge = hexdigest("md5", input*string(j))
  m = match(r"(.)\1{2}", challenge)
  !(m === Void()) && m[:1] in tracker && push!(output, m[:1])

  length(output) == 64 && break
  j += 1; i += 1
  shift!(tracker)
  pushHash!(tracker, i)
end

println("Task 1: $j")
