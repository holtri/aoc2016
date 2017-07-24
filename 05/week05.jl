using Nettle

input = "cxdnnyjw"

password = ""
i = 0

while length(password) < 8
  word = hexdigest("md5", input*string(i))
  ismatch(r"^00000.*", word) && (password = password * word[6:6])
  i+=1
end

println("Task1: password = $password")

password = fill("",8)
counter = 0
i = 0
while counter < 8
  word = hexdigest("md5", input*string(i))
  if isdigit(word[6]) && ismatch(r"^00000.*", word) && (0 ≤ parse(Int, word[6]) ≤ 7)
    idx = parse(Int, word[6]) + 1
    if password[idx] == ""
      password[idx] = string(word[7])
      counter += 1
      println("counter: $counter password: $password")
    end
  end
  i+=1
end

println("Task2: password = $password")
