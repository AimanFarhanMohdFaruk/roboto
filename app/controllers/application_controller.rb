class ApplicationController
  COMMANDS = {
    place: "PLACE",
    move: "MOVE",
    left: "LEFT",
    right: "RIGHT",
    report: "REPORT",
    help: "HELP",
    exit: "EXIT"
  }

  def initialize
    @board = Board.new(ENV.fetch("BOARD_HEIGHT", 5).to_i, ENV.fetch("BOARD_WIDTH", 5).to_i)
    @robot = Robot.new
    @logger = Logger.new(ENV.fetch("LOG_PATH"))
    @running = true
  end

  def run
    puts TTY::Box.info("Welcome to ROBOTO!\n", width: 79)
    render_instructions

    while @running do
      begin
        input = Readline.readline("\n> ", true).chomp
        break if input.strip.downcase == "exit"

        handle_input(input)
      rescue Interrupt
        puts "Exiting Roboto ..."
        break
      end
    end
  end

  private

  def handle_input(input)
    command, *args = input.split

    @logger.info("User input: #{command&.upcase}")
    case command&.upcase
    when COMMANDS[:place]
      handle_place(args.join)
    when COMMANDS[:move]
      @robot.move(@board)
    when COMMANDS[:left]
      @robot.left
    when COMMANDS[:right]
      @robot.right
    when COMMANDS[:report]
      puts @robot.report
    when COMMANDS[:help]
      render_instructions
    else
      puts "Unknown command: #{input}. Valid commands: PLACE, MOVE, LEFT, RIGHT, REPORT, EXIT."
    end

    if !@robot.errors.empty?
      @logger.warn("Error from Robot: #{@robot.errors.join(',')}")
      puts render_error(@robot.errors.join(','))
      @robot.errors = []
    end
  end

  def handle_place(args)
    x, y, direction = args.split(",")
    if x && y && direction
      x, y = x.to_i, y.to_i
      if @board.is_valid_placement?(x, y)
        @robot.place(x, y, direction, @board)
      else
        @logger.warn("User attempted to place robot out of bounds")
        puts render_error("Invalid position. Must be within the board dimensions.")
      end
    else
      puts render_error("Invalid PLACE command format. Use: PLACE X, Y, DIRECTION (NORTH, SOUTH, EAST, WEST)\n\nExample: PLACE 0,0,east")
    end
  end

  def render_error(err)
    error_message = TTY::Box.error(err)
    return error_message
  end

  def render_info(info)
    info_message = TTY::Box.info(info)
    return info_message
  end

  def render_instructions
    pastel = Pastel.new

    instructions = [
      {
        command: pastel.bold("PLACE"),
        description: <<~DESC
          Places your robot onto the board
          Format: #{pastel.green('PLACE X, Y, DIRECTION')} (#{pastel.cyan('NORTH, SOUTH, EAST, WEST')})
          Example: #{pastel.green('PLACE 0, 0, EAST')}
        DESC
      },
      {
        command: pastel.bold("MOVE"),
        description: "Moves the robot one unit forward in the direction it is currently facing."
      },
      {
        command: pastel.bold("LEFT"),
        description: "Turns the robot 90 degrees left, for example from east to north."
      },
      {
        command: pastel.bold("RIGHT"),
        description: "Turns the robot 90 degrees right, for example from north to east."
      },
      {
        command: pastel.bold("REPORT"),
        description: "Shows the current position of the robot and its direction."
      },
      {
        command: pastel.bold("HELP"),
        description: "Shows this instruction manual",
      },
      {
        command: pastel.red.bold("EXIT"),
        description: "Exits the program."
      }
    ]

    box_content = instructions.map do |inst|
      "#{inst[:command]}\n#{pastel.dim(inst[:description])}\n"
    end.join("\n")

    box = TTY::Box.frame(
      border: :thick,
      title: { top_left: ' Commands ' },
      align: :left,
      padding: 2,
    ) { box_content }

    puts box
  end
end
