# frozen_string_literal: false

# The Board class is meant to display the board and update it after every player move.
class Board
  SEPARATOR = '   ---|---|---'.freeze
  COLUMNS_LABELS = '    A   B   C '.freeze
  PLAYER1_MARK = ' X '.freeze
  PLAYER2_MARK = ' O '.freeze

  attr_accessor :lines, :move_counter

  def initialize
    @lines = ''
    @move_counter = 0
    send_board_to_players
  end

  def print_board
    puts(COLUMNS_LABELS, '')
    n = 0
    (lines.length - 1).times do
      puts lines[n].line.join('')
      puts SEPARATOR
      n += 1
    end
    puts lines[n].line.join('')
  end

  def register_latest_move(move)
    case move[1]
    when '1'
      edit_line1(move[0])
    when '2'
      edit_line2(move[0])
    when '3'
      edit_line3(move[0])
    end
    @move_counter += 1
  end

  private

  def send_board_to_players
    Player.board_used = self
  end

  def edit_line1(column)
    case column
    when 'A'
      lines[0].line[2] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'B'
      lines[0].line[4] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'C'
      lines[0].line[6] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    end
  end

  def edit_line2(column)
    case column
    when 'A'
      lines[1].line[2] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'B'
      lines[1].line[4] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'C'
      lines[1].line[6] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    end
  end

  def edit_line3(column)
    case column
    when 'A'
      lines[2].line[2] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'B'
      lines[2].line[4] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    when 'C'
      lines[2].line[6] = move_counter.even? ? PLAYER1_MARK : PLAYER2_MARK
    end
  end
end

# The Line class is meant to assign as many line instances as necessary to the board.
class Line
  @line_number = 0

  class << self
    attr_accessor :line_number
  end

  attr_accessor :line

  def initialize
    Line.line_number += 1
    @line = [Line.line_number, '  ', '   ', '|', '   ', '|', '   ']
  end

  def to_s
    line
  end

  def self.send_lines_to_board(target, number)
    lines_array = []
    number.times do
      lines_array.push(Line.new)
    end
    target.lines = lines_array
  end
end

# The Player class is meant to identify each player, retrieve their moves and check for a winning condition.
class Player
  VALID_ANSWERS = %w[A1 A2 A3 B1 B2 B3 C1 C2 C3].freeze
  @shared_tiles = []
  @board_used = []

  # This syntax is mandatory when using class instance variables.
  class << self
    attr_accessor :shared_tiles, :board_used
  end

  attr_accessor :tiles, :won

  def initialize(name)
    @name = name
    @tiles = {}
    @won = false
  end

  def select_tile
    puts "#{@name}, choose an empty tile by typing its identifier in a column-row format (for example, A1 for top left)."
    answer = gets.upcase.chomp
    answer = check_legality(answer)
    send_move_to_board(Player.board_used, answer)
    check_victory
  end

  private

  def check_legality(move)
    move = check_tile_occupied(move)
    move = check_valid_input(move)
    update_player_tile_list(move)
    Player.shared_tiles.push(move)
    move
  end

  def check_tile_occupied(move)
    until Player.shared_tiles.include?(move) == false
      puts 'This tile has already been selected! Please choose another one.'
      move = gets.upcase.chomp
    end
    move
  end

  def check_valid_input(move)
    until VALID_ANSWERS.include?(move)
      puts "Your answer isn't valid, please use the column-row notation (i.e. A1, B3, C2...)"
      move = gets.upcase.chomp
    end
    move
  end

  def update_player_tile_list(move)
    update_per_letter(move)
    update_per_number(move)
  end

  def update_per_letter(move)
    tiles[move[0]].nil? ? tiles[move[0]] = [move] : tiles[move[0]].push(move)
  end

  def update_per_number(move)
    tiles[move[1]].nil? ? tiles[move[1]] = [move] : tiles[move[1]].push(move)
  end

  def check_victory
    if tiles.any? { |_key, value| value.length == 3 } || check_diagonals == true
      puts "#{@name} wins!"
      @won = true
    elsif Player.shared_tiles.length == 9
      puts 'Draw!'
    end
  end

  def check_diagonals
    false unless tiles.any? { |_key, value| value.include?('B2') }
    diagonals_array = [check_upper_diagonal]
    diagonals_array.push(check_lower_diagonal)
    diagonals_array.any?(true) ? true : false
  end

  def check_upper_diagonal
    upper_diagonal_array = [tiles.any? { |_key, value| value.include?('A1') } ? true : false]
    upper_diagonal_array.push(tiles.any? { |_key, value| value.include?('C3') } ? true : false)
    upper_diagonal_array.all?(true) ? true : false
  end

  def check_lower_diagonal
    lower_diagonal_array = [tiles.any? { |_key, value| value.include?('A3') } ? true : false]
    lower_diagonal_array.push(tiles.any? { |_key, value| value.include?('C1') } ? true : false)
    lower_diagonal_array.all?(true) ? true : false
  end

  protected

  def send_move_to_board(target, move)
    target.register_latest_move(move)
  end
end

def play_game
  board = Board.new
  Line.send_lines_to_board(board, 3)
  puts "Player 1, you're X! What is your name?"
  player1 = Player.new(gets.capitalize.chomp)
  puts "Player 2, you're O! What is your name?"
  player2 = Player.new(gets.capitalize.chomp)
  play_turn(player1, player2, board)
end

def play_turn(player1, player2, board)
  until (player1 || player2).won == true || Player.shared_tiles.length == 9
    player1.select_tile
    board.print_board
    if (player1 || player2).won == true || Player.shared_tiles.length != 9
      player2.select_tile
      board.print_board
    end
  end
end

play_game
