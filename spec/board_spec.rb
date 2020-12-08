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
  end

# TEST(BoardTest, SlideNotOverEdge)
# {
#     BoardTestable board;
#     auto          number = Number::make(ARBITRARY_VALUE);
#     board.at(2, 0).place(number);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 0).hasNumber());
# }

# TEST(BoardTest, SlideStopOnNotMergeableNumber)
# {
#     BoardTestable board;
#     auto          moving_number   = Number::make(ARBITRARY_VALUE);
#     auto          blocking_number = Number::make(4 * ARBITRARY_VALUE);
#     board.at(2, 3).place(moving_number);
#     board.at(2, 0).place(blocking_number);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 1).hasNumber());
#     CHECK_EQUAL(ARBITRARY_VALUE, board.at(2, 1).number()->value());
#     CHECK_TRUE(board.at(2, 0).hasNumber());
#     CHECK_EQUAL(4 * ARBITRARY_VALUE, board.at(2, 0).number()->value());
# }

# TEST(BoardTest, SlideStopOnNotMergeableNumberAfterItsMove)
# {
#     BoardTestable board;
#     auto          moving_number          = Number::make(ARBITRARY_VALUE);
#     auto          moving_blocking_number = Number::make(4 * ARBITRARY_VALUE);
#     board.at(2, 3).place(moving_number);
#     board.at(2, 1).place(moving_blocking_number);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 1).hasNumber());
#     CHECK_EQUAL(ARBITRARY_VALUE, board.at(2, 1).number()->value());
#     CHECK_TRUE(board.at(2, 0).hasNumber());
#     CHECK_EQUAL(4 * ARBITRARY_VALUE, board.at(2, 0).number()->value());
# }

# TEST(BoardTest, SlideMoveAndMergeAtEdgeTwoMergeableNumbers)
# {
#     BoardTestable board;
#     auto          moving_number  = Number::make(ARBITRARY_VALUE);
#     auto          blocked_number = Number::make(ARBITRARY_VALUE);
#     board.at(2, 3).place(moving_number);
#     board.at(2, 1).place(blocked_number);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 0).hasNumber());
#     CHECK_FALSE(board.at(2, 1).hasNumber());
#     CHECK_FALSE(board.at(2, 2).hasNumber());
#     CHECK_FALSE(board.at(2, 3).hasNumber());
#     CHECK_EQUAL(2 * ARBITRARY_VALUE, board.at(2, 0).number()->value());
# }

# TEST(BoardTest, SlideNotMergeThirdMergeableNumber)
# {
#     BoardTestable board;
#     auto          moving_number         = Number::make(2 * ARBITRARY_VALUE);
#     Number    *   moving_num_ptr        = moving_number.get();
#     auto          moving_merging_number = Number::make(ARBITRARY_VALUE);
#     auto          blocked_number        = Number::make(ARBITRARY_VALUE);
#     board.at(2, 2).place(moving_number);
#     board.at(2, 1).place(moving_merging_number);
#     board.at(2, 0).place(blocked_number);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 0).hasNumber());
#     CHECK_TRUE(board.at(2, 1).hasNumber());
#     CHECK_FALSE(board.at(2, 2).hasNumber());
#     CHECK_FALSE(board.at(2, 3).hasNumber());
#     CHECK_EQUAL(2 * ARBITRARY_VALUE, board.at(2, 0).number()->value());
#     CHECK_EQUAL(2 * ARBITRARY_VALUE, board.at(2, 1).number()->value());
#     CHECK_EQUAL(moving_num_ptr, board.at(2, 1).number().get());
# }

# TEST(BoardTest, SlideMergeTwoByTwoOfFourEqualNumbers)
# {
#     BoardTestable board;
#     auto          num_0 = Number::make(ARBITRARY_VALUE);
#     auto          num_1 = Number::make(ARBITRARY_VALUE);
#     auto          num_2 = Number::make(ARBITRARY_VALUE);
#     auto          num_3 = Number::make(ARBITRARY_VALUE);
#     board.at(2, 0).place(num_0);
#     board.at(2, 1).place(num_1);
#     board.at(2, 2).place(num_2);
#     board.at(2, 3).place(num_3);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 0).hasNumber());
#     CHECK_TRUE(board.at(2, 1).hasNumber());
#     CHECK_FALSE(board.at(2, 2).hasNumber());
#     CHECK_FALSE(board.at(2, 3).hasNumber());
#     CHECK_EQUAL(2 * ARBITRARY_VALUE, board.at(2, 0).number()->value());
#     CHECK_EQUAL(2 * ARBITRARY_VALUE, board.at(2, 1).number()->value());
# }

# TEST(BoardTest, SlideMergeCouplesOfMergeableNumbers)
# {
#     BoardTestable board;
#     auto          num_0 = Number::make(ARBITRARY_VALUE);
#     auto          num_1 = Number::make(ARBITRARY_VALUE);
#     auto          num_2 = Number::make(2 * ARBITRARY_VALUE);
#     auto          num_3 = Number::make(2 * ARBITRARY_VALUE);
#     board.at(2, 0).place(num_0);
#     board.at(2, 1).place(num_1);
#     board.at(2, 2).place(num_2);
#     board.at(2, 3).place(num_3);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 0).hasNumber());
#     CHECK_TRUE(board.at(2, 1).hasNumber());
#     CHECK_FALSE(board.at(2, 2).hasNumber());
#     CHECK_FALSE(board.at(2, 3).hasNumber());
#     CHECK_EQUAL(2 * ARBITRARY_VALUE, board.at(2, 0).number()->value());
#     CHECK_EQUAL(4 * ARBITRARY_VALUE, board.at(2, 1).number()->value());
# }

# TEST(BoardTest, SlideMergeMiddleNumbers)
# {
#     BoardTestable board;
#     auto          num_0 = Number::make(ARBITRARY_VALUE);
#     auto          num_1 = Number::make(2 * ARBITRARY_VALUE);
#     auto          num_2 = Number::make(2 * ARBITRARY_VALUE);
#     auto          num_3 = Number::make(4 * ARBITRARY_VALUE);
#     board.at(2, 0).place(num_0);
#     board.at(2, 1).place(num_1);
#     board.at(2, 2).place(num_2);
#     board.at(2, 3).place(num_3);

#     board.slideLeft();

#     CHECK_TRUE(board.at(2, 0).hasNumber());
#     CHECK_TRUE(board.at(2, 1).hasNumber());
#     CHECK_TRUE(board.at(2, 2).hasNumber());
#     CHECK_FALSE(board.at(2, 3).hasNumber());
#     CHECK_EQUAL(ARBITRARY_VALUE, board.at(2, 0).number()->value());
#     CHECK_EQUAL(4 * ARBITRARY_VALUE, board.at(2, 1).number()->value());
#     CHECK_EQUAL(4 * ARBITRARY_VALUE, board.at(2, 2).number()->value());
# }















# TEST(BoardTest, PlaceNumberRandomly)
# {
#     BoardTestable board;
#     auto          number = Number::make(ARBITRARY_VALUE);

#     board.placeNumberRandomly(number);

#     CHECK_EQUAL(1, board.count());
# }

# TEST(BoardTest, PlaceNumberRandomlyOutOfSpace)
# {
#     BoardTestable board;
#     for(int i = 0; i < board.size(); ++i)
#     {
#         auto n = Number::make(ARBITRARY_VALUE);
#         board.placeNumberRandomly(n);
#     }
#     auto number = Number::make(ARBITRARY_VALUE);

#     CHECK_THROWS_STDEXCEPT(
#         std::runtime_error, "no space left on board",
#         board.placeNumberRandomly(number));
# }
end
