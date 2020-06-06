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
                break
            end
            unless piece.is_a?(Pawn)
                positions = pieces_to_array(@black_pieces).append(pieces_to_array(@white_pieces))
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

    def pieces_to_array(pieces)
        locations = []
        pieces.each do |piece|
            locations.push(piece.position)
        end
        return locations
    end
end

board = Board.new
board.place_board