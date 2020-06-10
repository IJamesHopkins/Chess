class Piece
    attr_accessor :position, :colour, :path, :moves
    def initialize(start = [0,0], colour="black", path =[])
        @colour = colour
        @path = path[0..-1]
        @path.push(start)
        @position = start
        @moves = []
    end

    def move(move_pos, ally_positions, all_positions = [])
        if self.valid_move?(move_pos) && !ally_positions.include?(move_pos)
            self.position = move_pos 
            path.push(move_pos)
            @moves = []
            return true
        else
            @moves = []
            return false
        end

    end

    def valid_move?(move, all_positions = [])
        if self.is_a?(Knight)
            self.submoves
        else
            self.submoves(all_positions)
        end
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
            if new_cords[0] <= 7 && new_cords[0] >= 0 && new_cords[1] <= 7 && new_cords[1] >= 0 
                @moves.push(new_cords)
            end
        end
    end

    def piece_token
        if self.colour == "black"
            return "♞"
        else
            return "♘"
        end
    end
end

class Rook < Piece
    MOVES = [[1,0],[-1,0],[0,1],[0,-1]]

    def submoves(all_positions)
        MOVES.each do |cords|
            stop_point = false
            new_cords = [cords[0] + @position[0], cords[1] + @position[1]]
            until stop_point do
                if new_cords[0] <= 7 && new_cords[0] >= 0 && new_cords[1] <= 7 && new_cords[1] >= 0
                    stop_point = true if all_positions.include?(new_cords)
                    @moves.push(new_cords)
                else
                    stop_point = true
                end
                new_cords = [cords[0] + new_cords[0], cords[1] + new_cords[1]]
            end
        end
    end

    def piece_token
        if self.colour == "black"
            return "♜"
        else
            return "♖"
        end
    end
end


class Bishop < Piece
    MOVES = [[1,1],[-1,-1],[-1,1],[1,-1]]

    def submoves(all_positions)
        MOVES.each do |cords|
            stop_point = false
            new_cords = [cords[0] + @position[0], cords[1] + @position[1]]
            until stop_point do
                new_cords = [cords[0] + new_cords[0], cords[1] + new_cords[1]]
                if new_cords[0] <= 7 && new_cords[0] >= 0 && new_cords[1] <= 7 && new_cords[1] >= 0
                    stop_point = true if all_positions.include?(new_cords)
                    @moves.push(new_cords)
                else
                    stop_point = true
                end
            end
        end
    end

    def piece_token
        if self.colour == "black"
            return "♝"
        else
            return "♗"
        end
    end
end

class Queen < Piece
    MOVES = [[1,1],[-1,-1],[-1,1],[1,-1],[1,0],[-1,0],[0,1],[0,-1]]

    def submoves(all_positions)
        MOVES.each do |cords|
            stop_point = false
            new_cords = [cords[0] + @position[0], cords[1] + @position[1]]
            until stop_point do
                new_cords = [cords[0] + new_cords[0], cords[1] + new_cords[1]]
                if new_cords[0] <= 7 && new_cords[0] >= 0 && new_cords[1] <= 7 && new_cords[1] >= 0
                    stop_point = true if all_positions.include?(new_cords)
                    @moves.push(new_cords)
                else
                    stop_point = true
                end
            end
        end
    end

    def piece_token
        if self.colour == "black"
            return "♛"
        else
            return "♕"
        end
    end
end

class King < Piece
    MOVES = [[1,1],[-1,-1],[-1,1],[1,-1],[1,0],[-1,0],[0,1],[0,-1]]

    def move(move_pos, ally_positions, check_in_pos)
        if self.valid_move?(move_pos, check_in_pos) && !ally_positions.include?(move_pos)
            self.position = move_pos 
            path.push(move_pos)
            @moves = []
            return true
        else
            @moves = []
            return false
        end

    end

    def valid_move?(move,check_in_pos)
        self.submoves
        if !check_in_pos && self.moves.include?(move)
            return true
        else
            return false
        end
    end

    def submoves
        MOVES.each do |cords|
            new_cords = [cords[0] + @position[0], cords[1] + @position[1]]
            if new_cords[0] <= 7 && new_cords[0] >= 0 && new_cords[1] <= 7 && new_cords[1] >= 0 
                @moves.push(new_cords)
            end
        end
    end

    def piece_token
        if self.colour == "black"
            return "♚"
        else
            return "♔"
        end
    end
    
end

class Pawn < Piece
    attr_accessor :position, :colour, :path, :moves, :first_move
    def initialize(start = [0,0], colour="black", path =[])
        @colour = colour
        @path = path[0..-1]
        @path.push(start)
        @position = start
        @moves = []
        @first_move = true
    end

    def move (new_position, ally_positions, enemy_positions)
        if self.valid_move?(new_position, ally_positions, enemy_positions)
            self.position = new_position
            path.push(new_position)
            @moves = []
            @first_move = false
            return true
        else
            @moves = []
            return false
        end
    end

    def submoves(ally_positions, enemy_positions)
        potential_moves = [-1,-2,0,1,2]
        potential_moves.each do |x|
            potential_moves.each do |y|
                new_position = [self.position[0] + x, self.position[1] + y]
                @moves.push(new_position) if valid_move?(new_position, ally_positions, enemy_positions)
            end
        end
    end
    #black at top, white bottom
    # [x, y] x= length, y=height
    def valid_move? (new_position, ally_positions, enemy_positions)
        return false if ally_positions.include?(new_position)
        return false if (new_position[1] - self.position[1]).abs > 1 && !first_move
        return false if (new_position[0] - self.position[0]).abs > 1
        if new_position[0] != self.position[0]
            return false unless enemy_positions.include?(new_position)
        end
        if enemy_positions.include?(new_position)
            return false unless (new_position[0] - self.position[0]).abs == 1
        end
        if self.colour == "black"
            return false if new_position[1] >= self.position[1]
        else
            return false if new_position[1] <= self.position[1]
        end
        return true
    end

    def piece_token
        if self.colour == "black"
            return "♟︎"
        else
            return "♙"
        end
    end
end