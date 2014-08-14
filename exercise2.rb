#Rovers' position on grid
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

#Class representing rovers that move forward
class Rover < Position

  #Constructor
  def initialize(start_point, heading)
    super(start_point.x, start_point.y)
    @heading = heading.upcase
  end

  #Gives rover's coordinates and direction it's heading 
  def to_s
    super + " #{@heading}"
  end

  #Moves the rover a given number of steps in the direction it was heading
  def forward(steps)
    if (@heading == 'N')
      incY(steps)
    elsif (@heading == 'S')
      decY(steps)
    elsif (@heading == 'E')
      incX(steps)
    elsif (@heading == 'W')
      decX(steps)
    end
  end  
end

rover1 = Rover.new(Position.new(0,0), 'N')
rover1.forward(1)
puts rover1