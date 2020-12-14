# frozen_string_literal: true

require 'board'

EXPECTED_BOARD_SIZE = 16
# ARBITRARY_VALUE     = 8;

describe Board do
  describe '.new' do
    it 'assign value' do
      b = Board.new

      expect(b.size).to  eql(EXPECTED_BOARD_SIZE)
      expect(b.count).to eql(0)
    end
  end

  describe 'at' do
    it 'inside does not throw' do
      b = Board.new

      b.at(0, 0)
      b.at(3, 3)
    end

    it 'up outside throws' do
      b = Board.new

      expect { b.at(-1, 0) }.to raise_error(
        RuntimeError, /out of board boundaries/
      )
    end

    it 'down outside throws' do
      b = Board.new

      expect { b.at(4, 0) }.to raise_error(
        RuntimeError, /out of board boundaries/
      )
    end

    it 'left outside throws' do
      b = Board.new

      expect { b.at(0, -1) }.to raise_error(
        RuntimeError, /out of board boundaries/
      )
    end

    it 'right outside throws' do
      b = Board.new

      expect { b.at(0, 4) }.to raise_error(
        RuntimeError, /out of board boundaries/
      )
    end

    it 'edge up left borders' do
      b = Board.new

      expect(b.at(0, 0).has_up).to eql(false)
      expect(b.at(0, 0).has_down).to eql(true)
      expect(b.at(0, 0).has_left).to eql(false)
      expect(b.at(0, 0).has_right).to eql(true)
    end

    it 'edge up right borders' do
      b = Board.new

      expect(b.at(0, 3).has_up).to eql(false)
      expect(b.at(0, 3).has_down).to eql(true)
      expect(b.at(0, 3).has_left).to eql(true)
      expect(b.at(0, 3).has_right).to eql(false)
    end

    it 'edge down left borders' do
      b = Board.new

      expect(b.at(3, 0).has_up).to eql(true)
      expect(b.at(3, 0).has_down).to eql(false)
      expect(b.at(3, 0).has_left).to eql(false)
      expect(b.at(3, 0).has_right).to eql(true)
    end

    it 'edge down right borders' do
      b = Board.new

      expect(b.at(3, 3).has_up).to eql(true)
      expect(b.at(3, 3).has_down).to eql(false)
      expect(b.at(3, 3).has_left).to eql(true)
      expect(b.at(3, 3).has_right).to eql(false)
    end

    describe 'slide' do
      it 'left' do
        b = Board.new
        n = Number.new(ARBITRARY_VALUE)
        b.at(2, 2).place(n)

        b.slide_left

        expect(b.at(2, 2).has_number).to eql(false)
        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 0).number).to eql(n)
      end

      it 'right' do
        b = Board.new
        n = Number.new(ARBITRARY_VALUE)
        b.at(1, 1).place(n)

        b.slide_right

        expect(b.at(1, 1).has_number).to eql(false)
        expect(b.at(1, 3).has_number).to eql(true)
        expect(b.at(1, 3).number).to eql(n)
      end

      it 'up' do
        b = Board.new
        n = Number.new(ARBITRARY_VALUE)
        b.at(2, 2).place(n)

        b.slide_up

        expect(b.at(2, 2).has_number).to eql(false)
        expect(b.at(0, 2).has_number).to eql(true)
        expect(b.at(0, 2).number).to eql(n)
      end

      it 'down' do
        b = Board.new
        n = Number.new(ARBITRARY_VALUE)
        b.at(1, 1).place(n)

        b.slide_down

        expect(b.at(1, 1).has_number).to eql(false)
        expect(b.at(3, 1).has_number).to eql(true)
        expect(b.at(3, 1).number).to eql(n)
      end

      it 'is applied to all numbers' do
        b     = Board.new
        n_1_1 = Number.new(ARBITRARY_VALUE)
        n_2_2 = Number.new(ARBITRARY_VALUE)
        n_3_3 = Number.new(ARBITRARY_VALUE)
        b.at(1, 1).place(n_1_1)
        b.at(2, 2).place(n_2_2)
        b.at(3, 3).place(n_3_3)

        b.slide_left

        expect(b.at(1, 1).has_number).to eql(false)
        expect(b.at(2, 2).has_number).to eql(false)
        expect(b.at(3, 3).has_number).to eql(false)
        expect(b.at(1, 0).has_number).to eql(true)
        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(3, 0).has_number).to eql(true)
      end
    end

    describe 'slide' do
      it 'not over board edge' do
        b = Board.new
        n = Number.new(ARBITRARY_VALUE)
        b.at(2, 0).place(n)

        b.slide_left

        expect(b.at(2, 0).has_number).to eql(true)
      end

      it 'stop on not mergeable number' do
        b          = Board.new
        moving_n   = Number.new(ARBITRARY_VALUE)
        blocking_n = Number.new(4 * ARBITRARY_VALUE)
        b.at(2, 3).place(moving_n)
        b.at(2, 0).place(blocking_n)

        b.slide_left

        expect(b.at(2, 1).has_number).to eql(true)
        expect(b.at(2, 1).number.value).to eql(ARBITRARY_VALUE)
        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 0).number.value).to eql(4 * ARBITRARY_VALUE)
      end

      it 'stop on not mergeable number after its move' do
        b                 = Board.new
        moving_n          = Number.new(ARBITRARY_VALUE)
        moving_blocking_n = Number.new(4 * ARBITRARY_VALUE)
        b.at(2, 3).place(moving_n)
        b.at(2, 1).place(moving_blocking_n)

        b.slide_left

        expect(b.at(2, 1).has_number).to eql(true)
        expect(b.at(2, 1).number.value).to eql(ARBITRARY_VALUE)
        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 0).number.value).to eql(4 * ARBITRARY_VALUE)
      end

      it 'move and merge at edge two mergeable numbers' do
        b         = Board.new
        moving_n  = Number.new(ARBITRARY_VALUE)
        blocked_n = Number.new(ARBITRARY_VALUE)
        b.at(2, 3).place(moving_n)
        b.at(2, 1).place(blocked_n)

        b.slide_left

        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 1).has_number).to eql(false)
        expect(b.at(2, 2).has_number).to eql(false)
        expect(b.at(2, 3).has_number).to eql(false)
        expect(b.at(2, 0).number.value).to eql(2 * ARBITRARY_VALUE)
      end

      it 'not merge third mergeable number' do
        b                 = Board.new
        moving_n          = Number.new(2 * ARBITRARY_VALUE)
        moving_merging_n  = Number.new(ARBITRARY_VALUE)
        blocked_n         = Number.new(ARBITRARY_VALUE)
        b.at(2, 2).place(moving_n)
        b.at(2, 1).place(moving_merging_n)
        b.at(2, 0).place(blocked_n)

        b.slide_left

        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 1).has_number).to eql(true)
        expect(b.at(2, 2).has_number).to eql(false)
        expect(b.at(2, 3).has_number).to eql(false)
        expect(b.at(2, 0).number.value).to eql(2 * ARBITRARY_VALUE)
        expect(b.at(2, 1).number.value).to eql(2 * ARBITRARY_VALUE)
        expect(b.at(2, 1).number).to eql(moving_n)
      end

      it 'merge two by two of four equal numbers' do
        b   = Board.new
        n_0 = Number.new(ARBITRARY_VALUE)
        n_1 = Number.new(ARBITRARY_VALUE)
        n_2 = Number.new(ARBITRARY_VALUE)
        n_3 = Number.new(ARBITRARY_VALUE)
        b.at(2, 0).place(n_0)
        b.at(2, 1).place(n_1)
        b.at(2, 2).place(n_2)
        b.at(2, 3).place(n_3)

        b.slide_left

        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 1).has_number).to eql(true)
        expect(b.at(2, 2).has_number).to eql(false)
        expect(b.at(2, 3).has_number).to eql(false)
        expect(b.at(2, 0).number.value).to eql(2 * ARBITRARY_VALUE)
        expect(b.at(2, 1).number.value).to eql(2 * ARBITRARY_VALUE)
      end

      it 'merge couples of mergeable numbers' do
        b   = Board.new
        n_0 = Number.new(ARBITRARY_VALUE)
        n_1 = Number.new(ARBITRARY_VALUE)
        n_2 = Number.new(2 * ARBITRARY_VALUE)
        n_3 = Number.new(2 * ARBITRARY_VALUE)
        b.at(2, 0).place(n_0)
        b.at(2, 1).place(n_1)
        b.at(2, 2).place(n_2)
        b.at(2, 3).place(n_3)

        b.slide_left

        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 1).has_number).to eql(true)
        expect(b.at(2, 2).has_number).to eql(false)
        expect(b.at(2, 3).has_number).to eql(false)
        expect(b.at(2, 0).number.value).to eql(2 * ARBITRARY_VALUE)
        expect(b.at(2, 1).number.value).to eql(4 * ARBITRARY_VALUE)
      end

      it 'merge middle numbers' do
        b   = Board.new
        n_0 = Number.new(ARBITRARY_VALUE)
        n_1 = Number.new(2 * ARBITRARY_VALUE)
        n_2 = Number.new(2 * ARBITRARY_VALUE)
        n_3 = Number.new(4 * ARBITRARY_VALUE)
        b.at(2, 0).place(n_0)
        b.at(2, 1).place(n_1)
        b.at(2, 2).place(n_2)
        b.at(2, 3).place(n_3)

        b.slide_left

        expect(b.at(2, 0).has_number).to eql(true)
        expect(b.at(2, 1).has_number).to eql(true)
        expect(b.at(2, 2).has_number).to eql(true)
        expect(b.at(2, 3).has_number).to eql(false)
        expect(b.at(2, 0).number.value).to eql(ARBITRARY_VALUE)
        expect(b.at(2, 1).number.value).to eql(4 * ARBITRARY_VALUE)
        expect(b.at(2, 2).number.value).to eql(4 * ARBITRARY_VALUE)
      end
    end

    describe 'place randomly' do
      it 'in empty board' do
        b = Board.new
        n = Number.new(ARBITRARY_VALUE)

        b.place_number_randomly(n)

        expect(b.count).to eql(1)
      end

      it 'when out of space' do
        b = Board.new
        for i in 0...b.size
          n = Number.new(ARBITRARY_VALUE)
          b.place_number_randomly(n)
        end

        n = Number.new(ARBITRARY_VALUE)

        expect { b.place_number_randomly(n) }.to raise_error(
          RuntimeError, /no space left on board/
        )
      end
    end
  end
end
