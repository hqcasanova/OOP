#Parent class
class Person
  def initialize(name)
    @name = name
  end

  #Greeting method
  def to_s
    "Hi, my name is #{@name}"
  end
end

#Child class
class Student < Person
  def learn
    puts "I get it!"
  end
end

#Child class
class Instructor < Person
  def teach
    puts "Everything in Ruby is an Object"
  end
end

#Instant birth and introductions
postgrad = Student.new("Cristina")
lecturer = Instructor.new("Chris")
puts postgrad
puts lecturer

lecturer.teach
postgrad.learn
#postgrad.teach
#lecturer.learn