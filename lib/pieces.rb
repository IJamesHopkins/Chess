class Piece
    attr_accessor :position, :colour, :path, :moves
    def initialize(start = [0,0], colour="black", path =[])
        @colour = colour
        @path = path[0..-1]
        @path.push(start)
        @position = start
        @moves = []
    end

    def move(move_pos, ally_positions)
        if self.valid_move?(move_pos) && !ally_positions.include?(move_pos)
            self.position = move_pos 
            return true
        else
            return false
        end

    end

    def valid_move?(move)
        self.submoves
        if self.moves.include?(move)
            return true
        else
            return false
        end
    end
end

class Knight < Piece
    MOVES = [[1,2], [2,1], [1,-2], [2,-1], [-1,2], [-2,1], [-1, -2], [-2,-1]]

    def submoves
        MOVES.each do |cords|
            new_cords = [cords[0] + @position[0], cords[1] + @position[1]]
            if new_cords[0] <= 8 && new_cords[0] >= 0 && new_cords[1] <= 8 && new_cords[1] >= 0 
                @moves.push(new_cords)
            end
        end
    end
end