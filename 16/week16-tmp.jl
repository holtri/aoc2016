function checkSum(s)
  return join(map(x -> if x[1] == x[2] "1" else "0" end, matchall(r".{2}", s)))
end

function calc(x, targetLength)
  while length(x) < targetLength
    s = reverse(x)
    s = replace(s, "0", "a")
    s = replace(s, "1", "0")
    s = replace(s, "a", "1")
    x *= "0" * s
  end
  x = x[1:targetLength]



  c = x
  while length(c) % 2 == 0
    c = checkSum(c)
  end
  return c
end

#println(calc("10111011111001111", 272))
@time calc("10111011111001111", 35651584)
