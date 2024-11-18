require_relative '../../app/models/robot'
require_relative '../../app/models/board'

RSpec.describe Robot do
  before do
    @robot = Robot.new
    @board = Board.new(ENV.fetch("BOARD_HEIGHT", 5).to_i, ENV.fetch("BOARD_WIDTH", 5).to_i)
  end

  describe "#place" do
    it "places the robot at the specified coordinates and direction" do
      @robot.place(0, 0, 'NORTH', @board)
      expect(@robot.position).to eq([0, 0])
      expect(@robot.direction).to eq('NORTH')
    end
  end

  describe "#move" do
    it "moves the robot one step forward in the current direction" do
      @robot.place(0, 0, 'NORTH', @board)
      @robot.move(@board)
      expect(@robot.position).to eq([0, 1])
    end
  end

  describe "#left" do
    it "rotates the robot to the left" do
      @robot.place(0, 0, 'NORTH', @board)
      @robot.left
      expect(@robot.direction).to eq('WEST')
    end
  end

  describe "#right" do
    it "rotates the robot to the right" do
      @robot.place(0, 0, 'NORTH', @board)
      @robot.right
      expect(@robot.direction).to eq('EAST')
    end
  end
end
