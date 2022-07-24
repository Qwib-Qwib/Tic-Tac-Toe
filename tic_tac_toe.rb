# frozen_string_literal: false

# The Board class is meant to display the board and update it after every player move.
class Board
  SEPARATOR = '   ---|---|---'.freeze
  COLUMNS_LABELS = '    A   B   C '.freeze

  def initialize
    @line1 = ['1     ', '|', '   ', '|', '   ']
    @line2 = ['2     ', '|', '   ', '|', '   ']
    @line3 = ['3     ', '|', '   ', '|', '   ']
  end

  def print_board
    puts COLUMNS_LABELS
    puts ''
    puts @line1.join('')
    puts SEPARATOR
    puts @line2.join('')
    puts SEPARATOR
    puts @line3.join('')
  end
end

# The Player class is meant to identify each player, retrieve their moves and check them for a winning condition.
class Player
  VALID_ANSWERS = %w[A1 A2 A3 B1 B2 B3 C1 C2 C3].freeze
  @shared_tiles = []

  # This syntax is mandatory when using class instance variables.
  class << self
    attr_accessor :shared_tiles
  end

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @tiles = []
  end

  def select_tile
    puts "#{@name}, choose an empty tile by typing its identifier in a column-row format (for example, A1 for top left)."
    answer = gets.upcase.chomp
    check_legality(answer)
  end

  private

  def check_legality(move)
    until Player.shared_tiles.include?(move) == false
      puts 'This tile has already been selected! Please choose another one.'
      move = gets.upcase.chomp
    end
    until VALID_ANSWERS.include?(move)
      puts "Your answer isn't valid, please use the column-row notation (i.e. A1, B3, C2...)"
      move = gets.upcase.chomp
    end
    @tiles.push(move)
    Player.shared_tiles.push(move)
  end
end
