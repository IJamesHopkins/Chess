require './lib/board.rb'
require "yaml"

def check_if_move (input)
    return false if input.length != 2
    return false if input[0] > 7 || input[0] < 0
    return false if input[1] > 7 || input[1] < 0
    return true
end
def enter_valid_move
    loop do
        puts "Not a valid move! Please enter a valid move"
        usr_input = gets.chomp.downcase
        piece = usr_input.split("").map {|s| s.to_i}
        return piece if check_if_move(piece)
    end

end
puts "Welcome to Chess!"
puts "What would you like to do? Type new for a new game, load to load a game or exit to quit"
initial = true
valid_move = true
checkmate = false
usr_input = gets.chomp.downcase

while initial
    break if usr_input == "exit"
    if usr_input == "new"
        board = Board.new
        board.standard_board
        usr_input = ""
        initial = false
    end
    if usr_input == "load"
        puts "What is the name of the file you would like to load"
        usr_input = gets.chomp
        fname = "#{usr_input}.txt"
        board = YAML::load(File.open(fname, "r"))
        usr_input = ""
        initial = false
    end
end

while usr_input != "exit" do
    if checkmate
        puts "The game is over!"
        puts "What would you like to do now? Create a (new) game, (load) a game or (exit)"
        usr_input = gets.chomp.downcase
        if usr_input == "new"
            board = Board.new
            board.standard_board
            checkmate = false
        elsif usr_input == "load"
            puts "What is the name of the file you would like to load"
            usr_input = gets.chomp
            fname = "#{usr_input}.txt"
            board = YAML::load(File.open(fname, "r"))
            checkmate = false
        elsif usr_input == "exit"
            break
        else
            next
        end
    end
    board.place_board
    puts "#{board.turn} to play!"
    puts "Enter the coordinates of the pieces you want to move, the horizontal axis is the first digit, vertical the second"
    puts "Or type (m)enu to access the menu"
    usr_input = gets.chomp.downcase
    break if usr_input == "exit"
    if usr_input == "menu" || usr_input == "m"
        puts "What would you like to do? Type new for a new game, exit to quit the game, save to save the game, load to load the game or play to make a move"
        usr_input = gets.chomp.downcase
        if usr_input == "new"
            board = Board.new
            board.standard_board
        elsif usr_input == "save"
            puts "What would you like the name of your file to be?"
            usr_input = gets.chomp
            saved_game = YAML::dump(board)
            fname = "#{usr_input}.txt"
            somefile = File.open(fname, "w")
            somefile.puts saved_game
            somefile.close
        elsif usr_input == "load"
            puts "What is the name of the file you would like to load"
            usr_input = gets.chomp
            fname = "#{usr_input}.txt"
            board = YAML::load(File.open(fname, "r"))
        elsif usr_input == "exit"
        end
        next
    end

    piece = usr_input.split("").map {|s| s.to_i}
    piece = enter_valid_move unless check_if_move(piece)

    puts "Enter the coordinates of where you want to move, the horizontal axis is the first digit, vertical the second"
    usr_input = gets.chomp

    new_location = usr_input.split("").map {|s| s.to_i}
    new_location = enter_valid_move unless check_if_move(new_location)

    good_move = board.move_piece(piece, new_location)
    board.switch_turn if good_move
    if board.check_public
        puts "Check"
        if board.checkmate?(board.turn)
            puts "Checkmate!"
            checkmate = true
        end
    end
end