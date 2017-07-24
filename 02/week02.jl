input = readcsv("input.txt")

mutable struct Position
  x::Int
  y::Int
end

# Task1
function update1(position::Position, direction::Char)
  direction == 'U' && (position.y = min(position.y + 1, 1))
  direction == 'D' && (position.y = max(position.y - 1, -1))
  direction == 'L' && (position.x = max(position.x - 1, -1))
  direction == 'R' && (position.x = min(position.x + 1, 1))
end

function toNumpad1(position::Position)
  numpad = [1 2 3; 4 5 6; 7 8 9]
  numpad[2 - position.y, 2 + position.x]
end

# Task2
function update2(position::Position, direction::Char)
  direction == 'U' && (position.y = min(position.y + 1, 2 - abs(position.x)))
  direction == 'D' && (position.y = max(position.y - 1, -2 + abs(position.x)))
  direction == 'L' && (position.x = max(position.x - 1, -2 + abs(position.y)))
  direction == 'R' && (position.x = min(position.x + 1, 2 - abs(position.y)))
end

function toNumpad2(position::Position)
  numpad = [0 0 1 0 0; 0 2 3 4 0; 5 6 7 8 9; 0 'A' 'B' 'C' 0; 0 0 'D' 0 0]
  numpad[3 - position.y, 3 + position.x]
end

function extractCode(input, startPosition, update::Function, toNumpad::Function)
  pos = startPosition
  for line in input
    for command in line
      update(pos, command)
    end
    print(toNumpad(pos))
  end
end

print("Task1 Code:"); extractCode(input, Position(0,0), update1, toNumpad1);
println()
print("Task2 Code:"); extractCode(input, Position(-2,0), update2, toNumpad2)
