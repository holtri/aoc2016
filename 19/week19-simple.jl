input = 3001330

function solve(input::Int)
  elves = [(x,1) for x in 1:input]
  i=1
  while i < length(elves)
    push!(elves, (elves[i][1], elves[i][2] + elves[i+1][2]))
    i +=2
  end
  elves[end]
end

solve(input)

function opposite(x::Int, len)
  tmp = (x + convert(Int, floor(len/2))) % (len)
  tmp > 0 ? tmp : len
end

function solve2(input)
  i = 1
  elves = [(x,1) for x in 1:input]
  while length(elves) > 1
    stealfrom = opposite(i, length(elves))
    # println("$(elves[i][1]) steals from $(elves[stealfrom][1])")
    elves[i] = (elves[i][1], elves[i][2] + elves[stealfrom][2])
    deleteat!(elves, stealfrom)
    i += 1
    i > length(elves) && (i=1)
    length(elves) % 1000 == 0 && println(length(elves))
  end
  elves[1]
end

# random deletion is too slow...
function poptest(x)
  tmp = ones(Int, x)
  for i in 1:x
    pop!(tmp)
  end

  function shifttest(x)
    tmp = ones(Int, x)
    for i in 1:x
      shift!(tmp)
    end
  end

function deletetest(x)
  tmp = ones(Int, x)
  for i in 1:x
    deleteat!(tmp,rand(1:length(tmp)))
  end
end

@time poptest(10^8)
@time shifttest(10^8)
@time poptest(10^5)
@time deletetest(10^5)

solve2(input)

type Node
  id::Int
  next::Node
  prev::Node

  function Node(id::Int)
    node = new(id)
    node.next = node
    node.prev = node
  end
  Node(id::Int, next::Node, prev::Node) = new(id,next,prev)
end

function deleteNode!(x::Node)
  x.prev.next = x.next
  x.next.prev = x.prev
end

function setupNodes(n)
  head = Node(1)
  current = head
  midpoint = Node(0)
  midid = iseven(n) ? convert(Int, n/2) + 1 : convert(Int, ceil(n/2))
  for i in 2:n
    nextNode = Node(i)
    current.next = nextNode
    nextNode.prev = current
    current = nextNode
    i == midid && ( midpoint = current)
  end
  current.next = head
  head.prev = current
  midpoint
end

function solve2fast(n)
  midpoint = setupNodes(n)
  while midpoint.next != midpoint
    deleteNode!(midpoint)
    n -= 1
    if n % 2 == 0
      tmp = midpoint.next.next
    else
      tmp = midpoint.next
    end
    midpoint = tmp
    # n % 1000 == 0 && println(n)
  end
  midpoint.id
end

@time solve2fast(3001330)
