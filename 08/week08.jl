input = readlines(open("input.txt"))
display = zeros(Matrix(6,50), Int)

function rect!(A, row, col)
  A[1:row, 1:col] = 1
end

function rotateRow!(A, row, steps)
  # A[row,1:end] = hcat(A[row,(end-steps+1):end]', A[row,1:(end-steps)]')
  A[row,:] = circshift(A[row,:], steps)
end

function rotateCol!(A, col, steps)
  # A[1:end,col] = hcat(A[(end-steps+1):end, col]', A[1:(end-steps), col]')
  A[:,col] = circshift(A[:,col], steps)
end

function roll!(A, operation)
  if operation[1] == "rect"
    dims = parse.(Int, split(operation[2], 'x'))
    rect!(display, dims[2], dims[1])
  else
    dim = parse(Int, operation[3][3:end]) + 1
    steps = parse(Int, operation[5])
    # println("rotate $(operation[2]) $dim by $steps steps")
    operation[2] == "column"? rotateCol!(display, dim, steps) : rotateRow!(display, dim, steps)
  end
end

for line in input
  operation = split(line, ' ')
  roll!(display, operation)
end

println("Task 1: $(sum(display))")

for r in indices(display)[1]
  println(foldl((x,y) -> x *(y==1?"#":"."),"",display[r,1:end]'))
end
