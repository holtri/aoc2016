using IterTools
input = readlines(open("input.txt"))

function containsABBA(x)
  length(x) < 4 && return false
  for i in 1:endof(x)-3
    x[i] != x[i+1] && x[i+1] == x[i+2] && x[i] == x[i+3] && return true
  end
  return false
end

clean(x) = strip(x, ['[', ']' ])

counter = 0
for line in input
  outside = any([containsABBA(clean(w)) for w in matchall(r"[a-z]*\[|\][a-z]*", line)])
  inside = any([containsABBA(clean(w)) for w in matchall(r"\[[a-z]*\]", line)])
  outside && !inside && (counter+=1)
end

println("Task 1: $counter")

extractABA(x) = [collect(w) for w in partition(x,3,1) if w[1] == w[3] && w[1] != w[2]]
extractABAs(pattern,x) = [w for s in matchall(pattern, x) for w in extractABA(clean(s))]
ABAtoBAB(x) = [x[2], x[1], x[2]]

counter = 0
for line in input
  inside =  extractABAs(r"\[[a-z]*\]", line)
  outside = [ABAtoBAB(x) for x in extractABAs(r"[a-z]*\[|\][a-z]*", line)]
  length(intersect(inside, outside)) > 0 && (counter += 1)
end

println("Task 2: $counter")
