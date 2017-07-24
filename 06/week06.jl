input = readlines(open("input.txt"))
input = reshape([line[idx] for line in input for idx in 1:length(line)], 8,:)

# selection = maximum # task1
selection = minimum # task2

for idx in 1:size(input)[1]
  word = input[idx, 1:end]
  tmp = reduce((a,b) -> merge(+,a,b), [Dict(x => 1) for x in word])
  print([i for (i,x) in tmp if x == selection(values(tmp))])
end
