# frozen_string_literal: true

require_relative '../../app/models/board'

RSpec.describe Board do
  before do
    @board = Board.new(ENV.fetch('BOARD_HEIGHT', 5).to_i, ENV.fetch('BOARD_WIDTH', 5).to_i)
  end

  describe '#is_valid_placement?' do
    it 'valid placement' do
      expect(@board.is_valid_placement?(0, 0)).to eq(true)
    end

    it 'invalid placement' do
      expect(@board.is_valid_placement?(-1, 10)).to eq(false)
    end
  end
end
