require './lib/pieces'

describe Knight do
    describe "#move" do
        it "moves the piece to x,y" do
            knight = Knight.new(0,0, "black")
            knight.move(1,2)
            expect(knight.position).to eql([1,2])
        end
    end
end