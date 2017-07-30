input = readlines(open("input.txt"))

mutable struct Bot
  id::Integer
  low::Nullable{Integer}
  high::Nullable{Integer}
  Bot(id) = Bot(id, Nullable(), Nullable())
  Bot(id, low, high) = low <= high ? new(id, low, high) : error("low > high")
end

function assign!(bot::Bot, value)
  if isnull(bot.low)
    bot.low = value
  else
    if get(bot.low) > value
       bot.high = bot.low
       bot.low = value
     else
       bot.high = value
     end
   end
end

function pushOutput!(dict::Dict{Integer, Vector{Integer}}, key, value)
    output = get!(dict, key, Vector{Integer}())
    push!(output, value)
    dict
end

bots = Dict{Integer, Bot}()
outputs = Dict{Integer, Vector{Integer}}()
commandQ = input

while length(commandQ) > 0
  command = shift!(commandQ)
  if startswith(command, "v")
    println(command)
    m = match(r"value (?<value>\d+) goes to bot (?<bot>\d+)", command)
    key = parse(Int,m[:bot])
    value = parse(Int,m[:value])
    bot = get!(bots, key, Bot(key))
    assign!(bot, value)
    println(bot)
  else
    m = match(r"bot (?<from>\d+) gives low to (?<lowtotype>(bot|output)) (?<lowtoid>(\d+)) and high to (?<hightotype>(bot|output)) (?<hightoid>(\d+))", command)
    fromid = parse(Int, m[:from])
    botfrom = get!(bots, fromid, Bot(fromid))
    if isnull(botfrom.low)|| isnull(botfrom.high)
      push!(commandQ, command)
      continue
    end

    if m[:lowtotype] == "bot"
      toid = parse(Int,m[:lowtoid])
      assign!(get!(bots, toid, Bot(toid)), get(botfrom.low))
    else
      pushOutput!(outputs, parse(Int,m[:lowtoid]), get(botfrom.low))
    end

    if m[:hightotype] == "bot"
      toid = parse(Int,m[:hightoid])
      assign!(get!(bots, toid, Bot(toid)), get(botfrom.high))
    else
      pushOutput!(outputs, parse(Int,m[:hightoid]), get(botfrom.low))
    end
  end
end #while

[b for b in values(bots) if get(b.low) == 17 && get(b.high) == 61]

reduce(*,[outputs[i][1] for i in 0:2])
