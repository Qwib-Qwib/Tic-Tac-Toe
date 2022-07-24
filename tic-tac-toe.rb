class Board

  SEPARATOR = "   ---|---|---"
  COLUMNS_LABELS = "    A   B   C "

  def initialize()
    @line1 = ["1     ", "|", "   ", "|", "   "]
    @line2 = ["2     ", "|", "   ", "|", "   "]
    @line3 = ["3     ", "|", "   ", "|", "   "]
  end

  def print_board()
    puts COLUMNS_LABELS
    puts ""
    puts @line1.join("")
    puts SEPARATOR
    puts @line2.join("")
    puts SEPARATOR
    puts @line3.join("")
  end

end

class Player

VALID_ANSWERS = ["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"]
@@shared_tiles = []

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @tiles = []
  end

  def select_tile()
    puts "#{@name}, choose an empty tile by typing its identifier in a column-row format (for example, A1 for top left)."
    answer = gets.upcase.chomp
    until @@shared_tiles.include?(answer) == false
      puts "This tile has already been selected! Please choose another one."
      answer = gets.upcase.chomp
    end
    until VALID_ANSWERS.include?(answer)
      puts "Your answer isn't valid, please use the column-row notation (i.e. A1, B3, C2...)"
      answer = gets.upcase.chomp
    end
    @tiles.push(answer)
    @@shared_tiles.push(answer)
  end

end