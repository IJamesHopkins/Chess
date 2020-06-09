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
end