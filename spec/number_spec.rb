# frozen_string_literal: true

require 'number'

ARBITRARY_VALUE = 8

describe Number do
  describe '.new' do
    it 'assign value' do
      n = Number.new(ARBITRARY_VALUE)
      expect(n.value).to eql(ARBITRARY_VALUE)
    end
  end

  describe '.new value less than two' do
    it 'throws' do
      expect { Number.new(1) }.to raise_error(RuntimeError, /value cannot be less than 2/)
    end
  end

  describe '.new value not power of two' do
    it 'throws' do
      expect { Number.new(3) }.to raise_error(RuntimeError, /value must be power of 2/)
    end
  end

  describe '.merge' do
    it 'merge double values' do
      n1 = Number.new(ARBITRARY_VALUE)
      n2 = Number.new(ARBITRARY_VALUE)

      n1.merge(n2)

      expect(n1.value).to eql(2 * ARBITRARY_VALUE)
    end
  end

  # TODO: merge mark as merged
  # TODO: merge mark as unusable?

  describe '.merge bad values' do
    it 'throws' do
      n1 = Number.new(ARBITRARY_VALUE)
      n2 = Number.new(2 * ARBITRARY_VALUE)

      expect { n1.merge(n2) }.to raise_error(
        RuntimeError, /merging numbers must have the same value and must have not been merged/
      )
    end
  end

  describe '.merge already merged' do
    it 'throws' do
      n1 = Number.new(ARBITRARY_VALUE)
      n2 = Number.new(ARBITRARY_VALUE)
      n3 = Number.new(2 * ARBITRARY_VALUE)
      n1.merge(n2)

      expect { n1.merge(n3) }.to raise_error(
        RuntimeError, /merging numbers must have the same value and must have not been merged/
      )
    end
  end
end
