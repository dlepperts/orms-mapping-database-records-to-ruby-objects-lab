class Student
  attr_accessor :id, :name, :grade

  # Creates an instance with corresponding attribute values
  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  # Retrieve all the rows from the "Students" database
  # Remember each row should be a new instance of the Student class
  def self.all

    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end

  end

  # Find the student in the database given a name
  # Return a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first

  end

  # Returns an array of all students in grades 9 
  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # Returns an array of all students in grades 11 or below
  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # returns an array of the first X students in grade 10 
  def self.first_X_students_in_grade_10(limit)
    
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT ?
    SQL

    DB[:conn].execute(sql,limit).map do |row|
      self.new_from_db(row)
    end

  end

  # Returns the first student in grade 10 
  def self.first_student_in_grade_10
    
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first

  end

# Returns an array of all students in a given grade X
def self.all_students_in_grade_X(grade)
    
  sql = <<-SQL
  SELECT *
  FROM students
  WHERE grade = ?
  SQL

  DB[:conn].execute(sql,grade).map do |row|
    self.new_from_db(row)
  end

end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
