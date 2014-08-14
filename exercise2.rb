
##########Rovers' position on grid
class Position
  attr_reader :x, :y

  #Constructor
  def initialize(x, y)
    @x = x
    @y = y
  end

  #Sets the maximum position possible on the grid (plateau)
  def self.set_max(max_x, max_y)
    @@max_x = max_x
    @@max_y = max_y
  end

  #Outputs coordinates
  def to_s
    "#{@x} #{@y}"
  end

  #Methods for forward movement. 'delta' is the size of the increment
  def incX(delta)
    @x += delta if (@x < 5)
  end
  def incY(delta)
    @y += delta if (@y < 5)
  end
  def decX(delta)
    @x -= delta if (@x > 0) 
  end
  def decY(delta)
    @y -= delta if (@y > 0)
  end
end

##########Class representing rovers that move forward
class Rover < Position
  #Possible headings
  @@headings = ['N', 'E', 'S', 'W']

  attr_reader :start_point, :heading, :name

  #Constructor
  def initialize(start_point, heading, name)
    super(start_point.x, start_point.y)
    @curr_heading = @@headings.index(heading.upcase)
    @name = name
  end

  #Gives rover's coordinates and direction it's heading 
  def to_s
    super + " #{@@headings[@curr_heading]}"
  end

  #Moves the rover a given number of steps in the direction it was heading
  def forward(steps)
    cardinal = @@headings[@curr_heading]
    if (cardinal == 'N')
      incY(steps)
    elsif (cardinal == 'S')
      decY(steps)
    elsif (cardinal == 'E')
      incX(steps)
    elsif (cardinal == 'W')
      decX(steps)
    else
      "Unrecognised cardinal: '#{cardinal}'"
    end
  end

  #Changes the rover's heading 90 deg left or right
  def spin(direction)
    direction.upcase!
    if (direction == 'L')
      @curr_heading = (@curr_heading - 1) % @@headings.length
    elsif (direction == 'R')
      @curr_heading = (@curr_heading + 1) % @@headings.length
    else 
      puts "Wrong argument: '#{direction}'"
    end 
  end

  #Processes the command message of spinning and forward commands from NASA. Forward commands are assumed to be of 1 step.
  def move(message)
    sequence = message.scan /\w/
    sequence.each do |command|
      if (command == 'L') || (command == 'R')
        spin(command)
      elsif (command == 'M')
        forward(1)
      else
        puts "Wrong command: '#{command}'"
      end
    end
  end
end

##########Convenience class encapsulating rover setup, command issue and execution
class Commander
  def initialize 
    puts "Please provide the name for the rover:"
    rover_name = gets.chomp
    puts "Please provide the coordinates and heading for rover #{rover_name} separated by spaces:"
    status = gets.chomp.split(' ')
    @new_rover = Rover.new(Position.new(status[0].to_i, status[1].to_i), status[2], rover_name)
    puts "Please provide the movement message to be sent to rover " + @new_rover.name + ":"
    @new_command = gets.chomp
  end

  def execute
    @new_rover.move(@new_command)
    puts "The current position of rover #{@new_rover.name}: #{@new_rover}"
  end
end

#Set maximum dimensions for plateau
puts "Please provide the maximum coordinates for the grid representing the plateau:"
max_coords = gets.chomp.split(' ')
Rover.set_max(max_coords[0], max_coords[1])

#Order rovers to move
rover1_command = Commander.new
rover1_command.execute
puts
rover2_command = Commander.new
rover2_command.execute