require 'position'

# ARBITRARY_VALUE = 8

describe Position do
  describe '.new' do
    it 'assign value' do
      p = Position.new
      expect(p.has_number).to eql(false)
      expect(p.has_left).to   eql(false)
      expect(p.has_right).to  eql(false)
      expect(p.has_up).to     eql(false)
      expect(p.has_down).to   eql(false)
    end
  end

  describe '.place' do
    it 'place number' do
      n = Number.new(ARBITRARY_VALUE)
      p = Position.new

      p.place(n)

      # TODO: expect usable false

      expect(p.has_number).to eql(true)
      expect(n).to eql(p.number)
    end
  end

  describe '.place twice' do
    it 'throws' do
      n1 = Number.new(ARBITRARY_VALUE)
      n2 = Number.new(ARBITRARY_VALUE)
      p = Position.new

      p.place(n1)

      expect { p.place(n2) }.to raise_error(
        RuntimeError, /position already contain a number/
      )
    end
  end

  describe '.left when has_left' do
    it 'return left' do
      p      = Position.new
      p_left = Position.new

      p.left = p_left

      expect(p.has_left).to eql(true)
      expect(p_left).to eql(p.left)
    end
  end

  describe '.left when empty' do
    it 'throws' do
      p = Position.new

      expect { p.left }.to raise_error(
        RuntimeError, /there is no left position/
      )
    end
  end

  describe '.right when has_right' do
    it 'return right' do
      p       = Position.new
      p_right = Position.new

      p.right = p_right

      expect(p.has_right).to eql(true)
      expect(p_right).to eql(p.right)
    end
  end

  describe '.right when empty' do
    it 'throws' do
      p = Position.new

      expect { p.right }.to raise_error(
        RuntimeError, /there is no right position/
      )
    end
  end

  describe '.up when has_up' do
    it 'return up' do
      p    = Position.new
      p_up = Position.new

      p.up = p_up

      expect(p.has_up).to eql(true)
      expect(p_up).to eql(p.up)
    end
  end

  describe '.up when empty' do
    it 'throws' do
      p = Position.new

      expect { p.up }.to raise_error(
        RuntimeError, /there is no up position/
      )
    end
  end

  describe '.down when has_down' do
    it 'return down' do
      p      = Position.new
      p_down = Position.new

      p.down = p_down

      expect(p.has_down).to eql(true)
      expect(p_down).to eql(p.down)
    end
  end

  describe '.down when empty' do
    it 'throws' do
      p = Position.new

      expect { p.down }.to raise_error(
        RuntimeError, /there is no down position/
      )
    end
  end

  describe '.transfer to empty place' do
    it 'place there' do
      n       = Number.new(ARBITRARY_VALUE)
      p_start = Position.new
      p_end   = Position.new
      p_start.place(n)

      p_start.transfer_to(p_end)

      expect(p_start.has_number).to eql(false)
      expect(p_end.has_number).to eql(true)
      expect(n).to eql(p_end.number)
    end
  end

  describe '.transfer to not empty place' do
    it 'merge there' do
      n_start = Number.new(ARBITRARY_VALUE)
      n_end   = Number.new(ARBITRARY_VALUE)
      p_start = Position.new
      p_end   = Position.new
      p_start.place(n_start)
      p_end.place(n_end)

      p_start.transfer_to(p_end)

      expect(p_start.has_number).to eql(false)
      expect(p_end.has_number).to eql(true)
      expect(2 * ARBITRARY_VALUE).to eql(p_end.number.value)
    end
  end
end
