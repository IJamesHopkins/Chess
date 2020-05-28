class Board

    def initialize
        @black_pieces = initial_board("black")
        @white_pieces = initial_board("white")
        @turn = "white"
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
end