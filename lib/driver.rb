require './lib/board.rb'

puts "Welcome to Chess!"
puts "What would you like to do? Type new for a new game, load to load a game or exit to quit"

usr_input = gets.chomp.downcase

while usr_input != "exit" do
    if usr_input == "new"
        board = Board.new
        board.standard_board
    end
    board.place_board
    puts "What would you like to do? Type new for a new game, exit to exit, save to save the game, load to load the game or play to make a move"
    usr_input = gets.chomp.downcase
    if usr_input == "new"
    elsif usr_input == "save"
    elsif usr_input == "load"
    elsif usr_input == "play"
        puts "#{board.turn} to play!"
        puts "Enter the coordinates of the pieces you want to move, the horizontal axis is the first digit, vertical the second"
        usr_input = gets.chomp
        piece = usr_input.split("").map {|s| s.to_i}
        puts "Enter the coordinates of where you want to move, the horizontal axis is the first digit, vertical the second"
        usr_input = gets.chomp
        new_location = usr_input.split("").map {|s| s.to_i}
        good_move = board.move_piece(piece, new_location)
        board.switch_turn if good_move
        if board.check_public
            puts "Check"
            if board.checkmate?(board.turn)
                puts "Checkmate!"
            end
        end
    elsif usr_input == "exit"
    end
end