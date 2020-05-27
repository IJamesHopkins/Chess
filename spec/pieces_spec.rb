require './lib/pieces'

describe Knight do
    describe "#move" do
        it "moves the piece to x,y" do
            knight = Knight.new([0,0], "black")
            knight.move([1,2], [])
            expect(knight.position).to eql([1,2])
        end
    end
end

describe Rook do
    describe "#move" do
        it "moves the piece to x,y" do
            rook = Rook.new([0,0], "black")
            rook.move([0,2], [], [[0,3]])
            expect(rook.position).to eql([0,2])
        end
    end
end


describe Bishop do
    describe "#move" do
        it "moves the piece to x,y" do
            bishop = Bishop.new([0,0], "black")
            bishop.move([2,2], [], [[2,3]])
            expect(bishop.position).to eql([2,2])
        end
    end
end

describe Queen do
    describe "#move" do
        it "moves the piece to x,y" do
            queen = Queen.new([0,0], "black")
            queen.move([2,2], [], [[2,3]])
            expect(queen.position).to eql([2,2])
        end
    end
end

describe King do
    describe "#move" do
        it "moves the piece to x,y" do
            king = King.new([0,0], "black")
            king.move([1,1], [], false)
            expect(king.position).to eql([1,1])
        end
    end
end