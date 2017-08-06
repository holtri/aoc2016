module circ_list

export CircularList, head

type ListElement{T}
  value::T
  next::ListElement{T}

  ListElement{T}(value::T, next::ListElement) where T = new{T}(value, next)

  function ListElement{T}(value::T) where T
    tmp = new{T}()
    tmp.value = value
    tmp.next = tmp
  end
end

type CircularList{T}
  head::Nullable{ListElement{T}}
  tail::Nullable{ListElement{T}}
end

CircularList{T}() where T = CircularList{T}(nothing, nothing)

Base.isempty(x::CircularList{T}) where T = isnull(x.head)

function Base.length(x::CircularList{T}) where T
  if isempty(x)
    return 0
  else
    count = 1
    current = head(x).next
    while current != head(x)
      count +=1
      current = current.next
    end
    return count
  end
end

function Base.push!(x::CircularList{T}, value::T) where T
  if isempty(x)
    x.head = ListElement{T}(value)
    x.tail = get(x.head)
  else
    x.head = ListElement{T}(value, get(x.head))
    tail = get(x.tail)
    tail.next = get(x.head)
  end
end

function head{T}(x::CircularList{T})
  isnull(x.head) && return nothing
  get(x.head)
end

function Base.show{T}(io::IO, x::CircularList{T})
  len = length(x)
  if isempty(x)
    print(io,"()")
  else
    print(io, "head: $(head(x).value) + $(len-1) more elements")
  end
end

end
