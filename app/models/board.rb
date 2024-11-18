# frozen_string_literal: true

class Board
  attr_reader :rows, :columns

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
  end

  def is_valid_placement?(x, y)
    x.between?(0, @columns - 1) && y.between?(0, @rows - 1)
  end
end
