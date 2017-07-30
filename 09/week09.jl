input = readline(open("input.txt"))

function decompress(word)
  total = 0
  #println("total: $total word: $word")
  w=1
#  if length(word) > 0
    while w ≤ length(word)
      if word[w] == '('
        c = match(r"(?<len>\d*)x(?<rep>\d*)", word[w:end])
        #println("len= $(c[:len]), rep=$(c[:rep])")
        clength = sum(map(length,c.captures)) + 2
        total += parse(Int, c[:rep]) *  (decompress( word[w + clength + 1: w + clength + parse(Int,c[:len])] ))
        w += clength + parse(Int,c[:len])
      else
        total += 1
      end # if
      w +=1
    end # while
  return total
end

decompress(input)
# output = ""; w=1
# while w ≤ length(input)
#   if input[w] == '('
#     c = match(r"(?<len>\d*)x(?<rep>\d*)", input[w:end])
#     clength = sum(map(length,c.captures))+2
#     output *=  repeat(input[w + clength + 1: w + clength + parse(Int,c[:len])], parse(Int,c[:rep]))
#     w+= clength + parse(Int,c[:len])
#   else
#     output *= input[w:w]
#   end
#   w +=1
#   #w > 100 && break
# end
#
# println("Task 1: $(length(output))")
