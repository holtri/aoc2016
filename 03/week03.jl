file = open("input.txt")
lines = readlines(file)

isValidTriangle(s1, s2, s3) = s1 < s2+s3 && s2 < s1 + s3 && s3 < s1 + s2

lines = map(x -> parse.(Int, split(x)), lines)
res = filter(x -> isValidTriangle(x[1], x[2], x[3]), lines) |> length

print("Part1: Numer of correct triangles: $res")

res = [isValidTriangle(lines[i][j], lines[i+1][j], lines[i+2][j]) for i in range(1, 3, convert(Int, length(lines)/3)), j in 1:3]

print("Part2: Number of correct triangles: $(sum(res))")
