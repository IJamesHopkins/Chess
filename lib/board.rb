require './lib/pieces.rb'

class Board
    attr_accessor :black_pieces, :white_pieces, :turn
    def initialize
        @black_pieces = []
        @white_pieces = []
        @turn = "white"
    end

    def standard_board
        @black_pieces = initial_board("black")
        @white_pieces = initial_board("white")
    end

    def initial_board(colour)
        piece_location = [6,7] if colour == "black"
        piece_location = [1,0] if colour == "white"
        pieces = []

        8.times do |x|
            pieces.push(Pawn.new([x,piece_location[0]],colour,[]))
        end
        pieces.push(Rook.new([0,piece_location[1]],colour,[]))
        pieces.push(Rook.new([7,piece_location[1]],colour,[]))
        pieces.push(Knight.new([1,piece_location[1]],colour,[]))
        pieces.push(Knight.new([6,piece_location[1]],colour,[]))
        pieces.push(Bishop.new([2,piece_location[1]],colour,[]))
        pieces.push(Bishop.new([5,piece_location[1]],colour,[]))
        pieces.push(Queen.new([3,piece_location[1]],colour,[]))
        pieces.push(King.new([4,piece_location[1]],colour,[]))
        return pieces
    end

    def place_board
        8.times do |x|
            8.times do |y|
                piece_to_put = piece_at_location([y,x])
                print "| #{piece_to_put} "
            end
            print "| \n"
            8.times do
                print "----"
            end
            print "-\n"
        end
    end

    def switch_turn
        if @turn == "black"
            @turn = "white"
        else
            @turn = "black"
        end
    end

    def move_piece (current_loc, new_loc)
        if @turn == "black"
            pieces = @black_pieces
            antipieces = @white_pieces
        else
            pieces = @white_pieces
            antipieces = @black_pieces
        end
        all_pieces = pieces[0..-1]
        all_pieces.concat(antipieces)
        piecehere = false
        piece_to_move = nil
        pieces.each do |piece|
            if piece.position == current_loc
                piecehere = true
                piece_to_move = piece
                break
            end
        end
        unless piecehere
            puts "No piece at this location!"
            return false
        end
        if piece_to_move.is_a?(Pawn)
            valid_move = piece_to_move.move(new_loc, pieces_to_array(pieces), pieces_to_array(antipieces))
        else
            valid_move = piece_to_move.move(new_loc,pieces_to_array(pieces), pieces_to_array(all_pieces))
        end

        if valid_move
            piece_to_del = false
            antipieces.each_with_index do |piece, index|
                if piece.position == new_loc
                    piece_to_del = index
                    break
                end
            end
            if piece_to_del
                antipieces.delete_at(piece_to_del)
            end
            return true
        else
            puts "invalid move"
            return false
        end

    end

    def piece_at_location(loc)
        @black_pieces.each do |piece|
            if piece.position == loc
                return piece.piece_token
            end
        end

        @white_pieces.each do |piece|
            if piece.position == loc
                return piece.piece_token
            end
        end
        return " "
    end
    
    def check? (pieces, king_pos)
        pieces.each do |piece|
            if piece.is_a?(Knight) || piece.is_a?(King)
                piece.submoves
                return true if piece.moves.include?(king_pos)
                next
            end
            unless piece.is_a?(Pawn)
                positions = pieces_to_array(@black_pieces).concat(pieces_to_array(@white_pieces))
                piece.submoves(positions)
                return true if piece.moves.include?(king_pos)
            end
            if piece.is_a?(Pawn)
                pawn_location = piece.position
                if piece.colour == "white"
                    return true if [pawn_location[0] - 1, pawn_location[1] + 1] == king_pos
                    return true if [pawn_location[0] + 1, pawn_location[1] + 1] == king_pos
                else
                    return true if [pawn_location[0] - 1, pawn_location[1] - 1] == king_pos
                    return true if [pawn_location[0] + 1, pawn_location[1] - 1] == king_pos
                end
            end
        end
        return false
    end


    def check_public
        if self.turn == "black"
            return check?(@white_pieces, find_king(@black_pieces))
        else
            return check?(@black_pieces, find_king(@white_pieces))
        end
    end

    def checkmate? (colour)
        if colour == "white"
            pieces = @white_pieces
            attacking_pieces = @black_pieces
        else
            pieces = @black_pieces
            attacking_pieces = @white_pieces
        end
        new_pos = 0
        old_pos = 0
        delete_ind = nil

        pieces.each do |piece|
            if piece.is_a?(Knight) || piece.is_a?(King)
                piece.submoves
                old_pos = piece.position
                piece.moves.each do |new_move|
                    next if pieces_to_array(pieces).include?(new_move)
                    if pieces_to_array(attacking_pieces).include?(new_move)
                        pieces_to_check = attacking_pieces[0..-1]
                        pieces_to_check.each_with_index do |val, ind|
                            if val.position == new_move
                                delete_ind = ind
                                break
                            end
                        end
                        pieces_to_check.delete_at(delete_ind)
                    else
                        pieces_to_check = attacking_pieces
                    end
                    piece.position = new_move
                    unless check?(pieces_to_check, find_king(pieces))
                        piece.position = old_pos
                        return false
                    end
                end
                piece.position = old_pos
            elsif piece.is_a?(Pawn)
                piece.submoves(pieces_to_array(pieces), pieces_to_array(attacking_pieces))
                old_pos = piece.position
                piece.moves.each do |new_move|
                    next if pieces_to_array(pieces).include?(new_move)
                    if pieces_to_array(attacking_pieces).include?(new_move)
                        pieces_to_check = attacking_pieces[0..-1]
                        pieces_to_check.each_with_index do |val, ind|
                            if val.position == new_move
                                delete_ind = ind
                                break
                            end
                        end
                        pieces_to_check.delete_at(delete_ind)
                    else
                        pieces_to_check = attacking_pieces
                    end
                    piece.position = new_move
                    unless check?(pieces_to_check, find_king(pieces))
                        piece.position = old_pos
                        return false
                    end
                end
                piece.position = old_pos
            else
                old_pos = piece.position
                piece.submoves(pieces_to_array(@black_pieces).concat(pieces_to_array(@white_pieces)))
                piece.moves.each do |new_move|
                    next if pieces_to_array(pieces).include?(new_move)
                    if pieces_to_array(attacking_pieces).include?(new_move)
                        pieces_to_check = attacking_pieces[0..-1]
                        pieces_to_check.each_with_index do |val, ind|
                            if val.position == new_move
                                delete_ind = ind
                                break
                            end
                        end
                        pieces_to_check.delete_at(delete_ind)
                    else
                        pieces_to_check = attacking_pieces
                    end
                    piece.position = new_move
                    unless check?(pieces_to_check, find_king(pieces))
                        piece.position = old_pos
                        return false
                    end
                end
                piece.position = old_pos
            end
        end
        return true

    end

    def find_king(pieces)
        pieces.each do |piece|
            if piece.is_a?(King)
                return piece.position
            end
        end
        return false
    end

    def pieces_to_array(pieces)
        locations = []
        pieces.each do |piece|
            locations.push(piece.position)
        end
        return locations
    end
end
