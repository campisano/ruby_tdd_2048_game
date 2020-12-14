# frozen_string_literal: true

require 'position'

class Board
  def initialize
    @positions = Array.new(EDGE_SIZE) { Array.new(EDGE_SIZE) { Position.new } }

    for row in (0 ... EDGE_SIZE)
      for col in (0 ... EDGE_SIZE)
        if row > 0
          @positions[row][col].up = (@positions[row - 1][col])
        end
        if row < (EDGE_SIZE - 1)
          @positions[row][col].down = (@positions[row + 1][col])
        end
        if col > 0
          @positions[row][col].left = (@positions[row][col - 1])
        end
        if col < (EDGE_SIZE - 1)
          @positions[row][col].right = (@positions[row][col + 1])
        end
      end
    end
  end

  def slide_left
    for row in (0 ... EDGE_SIZE)
      for col in (1 ... EDGE_SIZE)
        if @positions[row][col].has_number
          slide_from(
            @positions[row][col],
            :has_left,
            :left
          )
        end
      end
    end
    a = EDGE_SIZE - 2
  end

  def slide_right
    for row in (0 ... EDGE_SIZE)
      for col in (EDGE_SIZE - 2 ).downto(0)
        if @positions[row][col].has_number
          slide_from(
            @positions[row][col],
            :has_right,
            :right
          )
        end
      end
    end
  end

  def slide_up
    for col in (0 ... EDGE_SIZE)
      for row in (1  ... EDGE_SIZE)
        if @positions[row][col].has_number
          slide_from(
            @positions[row][col],
            :has_up,
            :up
          )
        end
      end
    end
  end

  def slide_down
    for col in (0 ... EDGE_SIZE)
      for row in (EDGE_SIZE - 2).downto(0)
        if @positions[row][col].has_number
          slide_from(
            @positions[row][col],
            :has_down,
            :down
          )
        end
      end
    end
  end

  def place_number_randomly(number)
    free_pos = size - count

    if free_pos == 0
      raise('no space left on board')
    end

    rand_pos = generate_random_place(free_pos - 1)

    for row in (0 ... EDGE_SIZE)
      for col in (0  ... EDGE_SIZE)
        if ! @positions[row][col].has_number
          if rand_pos == 0
            @positions[row][col].place(number)
            return
          else
            rand_pos -= 1
          end
        end
      end
    end
  end

  def size
    EDGE_SIZE * EDGE_SIZE
  end

  def at(row, column)
    if row.negative? || row >= EDGE_SIZE || column.negative? || column >= EDGE_SIZE
      raise('out of board boundaries')
    end

    @positions[row][column]
  end

  def count
    count = 0
    for row in (0 ... EDGE_SIZE)
      for col in (0 ... EDGE_SIZE)
        if @positions[row][col].has_number
          count += 1
        end
      end
    end
    count
  end

  private # TODO: useless??

  def slide_from(position, has_direction, at_direction)
    dest = position
    while (dest.send has_direction) &&
          (
            !(dest.send at_direction).has_number ||
            (dest.send at_direction).number.can_merge(position.number)
          )
      dest = (dest.send at_direction)
    end

    if dest != position
      position.transfer_to(dest)
    end
  end

  def generate_random_place(limit)
    rand(0..limit)
  end

  EDGE_SIZE = 4
end
