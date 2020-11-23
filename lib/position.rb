class Position
  def initialize
    @left   = nil
    @right  = nil
    @up     = nil
    @down   = nil
    @number = nil
  end

  def has_number
    @number != nil
  end

  def number
    @number
  end

  def place(number)
    raise('position already contain a number') if has_number

    @number = number
  end

  def has_left
    @left != nil
  end

  def left
    raise('there is no left position') unless has_left

    @left
  end

  def left=(position)
    @left = position
  end

  def has_right
    @right != nil
  end

  def right
    raise('there is no right position') unless has_right

    @right
  end

  def right=(position)
    @right = position
  end

  def has_up
    @up != nil
  end

  def up
    raise('there is no up position') unless has_up

    @up
  end

  def up=(position)
    @up = position
  end

  def has_down
    @down != nil
  end

  def down
    raise('there is no down position') unless has_down

    @down
  end

  def down=(position)
    @down = position
  end

  def transfer_to(position)
    if position.has_number
      position.number.merge(@number)
    else
      position.place(@number)
    end
    @number = nil
  end
end
