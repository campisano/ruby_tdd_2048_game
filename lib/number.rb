# frozen_string_literal: true

class Number
  def initialize(value)
    raise('value cannot be less than 2') if value < 2
    raise('value must be power of 2')    unless is_power_of_two(value)

    @merged = false
    @value = value
  end

  def value
    @value
  end

  def merge(number)
    raise('merging numbers must have the same value and must have not been merged') unless can_merge(number)

    @value += number.value
    @merged = true
  end

  private

  def is_power_of_two(value)
    (value > 0) && ((value & (value - 1)) == 0)
  end

  def can_merge(number)
    !@merged && !number.instance_variable_get('@merged') &&
      number.instance_variable_get('@value') == @value
  end
end
