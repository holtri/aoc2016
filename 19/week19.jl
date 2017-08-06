include("./circular_list.jl")
using circ_list
import circ_list.ListElement

using Base
input = 3001330

type Elve
  id::Int
  gifts::Int
end

struct NoSuchElementError <: Exception end

function removeNextElement{T}(l::CircularList{T}, x::ListElement{T})
  if x.next == x
    throw(NoSuchElementError())
  else
    if l.head == x
      l.head = x.next
    end
    x.next = x.next.next
  end
end

elves = CircularList{Elve}()

length(elves)
for i in reverse(1:input)
  push!(elves, Elve(i,1))
end

# current.value
# length(elves)
current = head(elves)
counter = 0
while length(elves) > 1
  (counter % 1000) == 0 && println(length(elves))
  counter +=1
  current.value.gifts += current.next.value.gifts
  removeNextElement(elves, current)
end

head(elves).value
