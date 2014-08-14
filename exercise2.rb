
##########Rovers' position on grid
class Position
  attr_reader :x, :y

  #Constructor
  def initialize(x, y)
    @x = x
    @y = y
  end

  #Sets the maximum position possible on the grid
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

  #Constructor
  def initialize(start_point, heading)
    super(start_point.x, start_point.y)
    @curr_heading = @@headings.index(heading.upcase)
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
end

rover1 = Rover.new(Position.new(1,2), 'N')
rover1.spin('L')
rover1.forward(1)
rover1.spin('L')
rover1.forward(1)
rover1.spin('L')
rover1.forward(1)
rover1.spin('L')
rover1.forward(1)
rover1.forward(1)
puts rover1

rover2 = Rover.new(Position.new(3,3), 'E')
rover2.forward(1)
rover2.forward(1)
rover2.spin('R')
rover2.forward(1)
rover2.forward(1)
rover2.spin('R')
rover2.forward(1)
rover2.spin('R')
rover2.spin('R')
rover2.forward(1)
puts rover2