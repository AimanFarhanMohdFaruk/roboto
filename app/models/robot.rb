# frozen_string_literal: true

class Robot
  attr_accessor :position, :direction, :errors

  DIRECTIONS = %w[NORTH EAST SOUTH WEST].freeze

  def initialize
    @position = nil
    @direction = DIRECTIONS[0]
    @errors = []
  end

  def place(x, y, direction, _board)
    validate_direction(direction)
    return unless @errors.empty?

    @position = [x, y]
    @direction = direction.upcase
  end

  def left
    validate_placed

    current_direction_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_direction_index - 1) % 4]
  end

  def right
    validate_placed

    current_direction_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_direction_index + 1) % 4]
  end

  def report
    validate_placed
    return unless @errors.empty?

    "#{@position[0]}, #{@position[1]}, #{direction}"
  end

  def move(board)
    return unless @position

    new_position = case @direction.upcase
                   when 'NORTH' then [@position[0], @position[1] + 1]
                   when 'SOUTH' then [@position[0], @position[1] - 1]
                   when 'EAST' then [@position[0] + 1, @position[1]]
                   when 'WEST' then [@position[0] - 1, @position[1]]
                   end

    place(new_position[0], new_position[1], @direction, board) if board.valid_placement?(new_position[0],
                                                                                            new_position[1])
  end

  private

  def validate_placed
    errors << I18n.t('robot.not_placed') unless @position
  end

  def validate_direction(direction)
    errors << I18n.t('robot.invalid_direction') unless DIRECTIONS.include?(direction.upcase)
  end
end
