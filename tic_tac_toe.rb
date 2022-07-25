# frozen_string_literal: false

# The Board class is meant to display the board and update it after every player move.
class Board
  SEPARATOR = '   ---|---|---'.freeze
  COLUMNS_LABELS = '    A   B   C '.freeze
  PLAYER1_MARK = ' X '.freeze
  PLAYER2_MARK = ' O '.freeze

  @line1 = ['1', '  ', '   ', '|', '   ', '|', '   ']
  @line2 = ['2', '  ', '   ', '|', '   ', '|', '   ']
  @line3 = ['3', '  ', '   ', '|', '   ', '|', '   ']

  @move_counter = 0

  # This syntax is mandatory when using class instance variables.
  class << self
    attr_accessor :move_counter, :line1, :line2, :line3
  end

  def initialize
    @line1 = ['1', '  ', '   ', '|', '   ', '|', '   ']
    @line2 = ['2', '  ', '   ', '|', '   ', '|', '   ']
    @line3 = ['3', '  ', '   ', '|', '   ', '|', '   ']
  end

  def self.print_board
    puts COLUMNS_LABELS
    puts ''
    puts @line1.join('')
    puts SEPARATOR
    puts @line2.join('')
    puts SEPARATOR
    puts @line3.join('')
  end

  def self.register_latest_move(move)
    case move[1]
    when '1'
      edit_line1(move[0])
    when '2'
      edit_line2(move[0])
    when '3'
      edit_line3(move[0])
    end
    Board.move_counter += 1
  end

  def self.edit_line1(column)
    case column
    when 'A'
      line1[2] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'B'
      line1[4] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'C'
      line1[6] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    end
  end

  def self.edit_line2(column)
    case column
    when 'A'
      line2[2] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'B'
      line2[4] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'C'
      line2[6] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    end
  end

  def self.edit_line3(column)
    case column
    when 'A'
      line3[2] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'B'
      line3[4] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'C'
      line3[6] = Board.move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    end
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

  def initialize(name)
    @name = name
    @tiles = []
  end

  def select_tile
    puts "#{@name}, choose an empty tile by typing its identifier in a column-row format (for example, A1 for top left)."
    answer = gets.upcase.chomp
    answer = check_legality(answer)
    send_move_to_board(Board, answer)
  end

  private

  def check_legality(move)
    check_tile_occupied(move)
    check_valid_input(move)
    @tiles.push(move)
    Player.shared_tiles.push(move)
    move
  end

  def check_tile_occupied(move)
    until Player.shared_tiles.include?(move) == false
      puts 'This tile has already been selected! Please choose another one.'
      move = gets.upcase.chomp
    end
  end

  def check_valid_input(move)
    until VALID_ANSWERS.include?(move)
      puts "Your answer isn't valid, please use the column-row notation (i.e. A1, B3, C2...)"
      move = gets.upcase.chomp
    end
  end

  protected

  def send_move_to_board(target, move)
    target.register_latest_move(move)
  end
end

player1 = Player.new('Juju')
player2 = Player.new('Jojo')
player1.select_tile
Board.print_board
player2.select_tile
Board.print_board
