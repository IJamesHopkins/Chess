require './lib/board'

describe Board do
    describe "#move_piece" do
        it "moves a pawn from one position to the next" do
            board = Board.new
            pieces = []
            pieces.push(Pawn.new([7,1],"white",[]))
            board.white_pieces = pieces
            board.move_piece([7,1], [7,3])
            expect(board.white_pieces[0].position).to eql([7,3])
            expect(board.move_piece([0,0],[1,1])).to eql(false)
            expect(board.move_piece([7,3], [7,5])).to eql(false)
            expect(board.white_pieces[0].position).to eql([7,3])
        end
        it "moves a piece to an enemy location" do
            board = Board.new
            board.white_pieces.push(Rook.new([0,0], "white", []))
            board.black_pieces.push(Rook.new([5,0], "black", []))
            expect(board.move_piece([0,0],[5,0])).to eql(true)
            expect(board.white_pieces[0].position).to eql([5,0])
            expect(board.black_pieces[0]).to eql(nil)
        end
    end
    describe "#check?" do
        it "checks if something is in check given a list of enemy pieces and a king position" do
            board = Board.new
            pieces = []
            pieces.push(Rook.new([7,5],"black",[]))
            expect(board.check?(pieces, [7,2])).to eql(true)
        end
        it "checks for check with knight" do
            board = Board.new
            pieces = []
            pieces.push(Knight.new([7,5],"black",[]))
            expect(board.check?(pieces, [6,3])).to eql(true)
        end
        it "checks for check with numerous pieces on the board" do
            board = Board.new
            pieces = []
            pieces.push(Rook.new([7,5],"black",[]))
            pieces.push(Pawn.new([7,3],"black",[]))
            board.black_pieces = pieces
            expect(board.check?(pieces, [7,2])).to eql(false)
        end
        it "checks for check with a pawn" do
            board = Board.new
            pieces = []
            pieces.push(Pawn.new([1,3],"black",[]))
            expect(board.check?(pieces, [7,2])).to eql(false)
            pieces.push(Pawn.new([6,3],"black",[]))
            board.black_pieces = pieces
            expect(board.check?(pieces, [7,2])).to eql(true)
        end
    end
    describe "#checkmate?" do
        it "checks if a player is in checkmate" do
            board = Board.new
            pieces = []
            board.black_pieces.push(King.new([0,0], "black", []))
            pieces.push(Rook.new([0,5], "white", []))
            pieces.push(Rook.new([5,0], "white", []))
            pieces.push(Bishop.new([5,5], "white", []))
            board.white_pieces = pieces
            expect(board.checkmate?("black")).to eql(true)
            expect(board.black_pieces[0].position).to eql([0,0])
        end
        it "checks if a player is not in checkmate" do
            board = Board.new
            pieces = []
            board.black_pieces.push(King.new([0,0], "black", []))
            pieces.push(Rook.new([0,5], "white", []))
            pieces.push(Rook.new([5,0], "white", []))
            board.white_pieces = pieces
            expect(board.checkmate?("black")).to eql(false)
            expect(board.black_pieces[0].position).to eql([0,0])
        end
        it "checks if a player is in checkmate" do
            board = Board.new
            pieces = []
            board.black_pieces.push(King.new([0,0], "black", []))
            board.black_pieces.push(Queen.new([6,6], "black",[]))
            pieces.push(Rook.new([0,5], "white", []))
            pieces.push(Rook.new([5,0], "white", []))
            pieces.push(Bishop.new([5,5], "white", []))
            board.white_pieces = pieces
            expect(board.checkmate?("black")).to eql(true)
            expect(board.black_pieces[0].position).to eql([0,0])
        end
        it "checks if a player is in checkmate with pawns" do
            board = Board.new
            pieces = []
            board.white_pieces.push(King.new([0,0], "white", []))
            board.white_pieces.push(Pawn.new([1,0], "white",[]))
            pieces.push(Rook.new([5,1], "black", []))
            pieces.push(Bishop.new([5,5], "black", []))
            board.black_pieces = pieces
            expect(board.checkmate?("white")).to eql(false)
            expect(board.white_pieces[0].position).to eql([0,0])
        end
    end
end