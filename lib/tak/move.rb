module Tak
  class Move
    attr_reader :move
    attr_reader :origin

    OBSTRUCTIONS = %w(Cw Cb Sw Sb)

    def initialize(ptn, board)
      @move   = Tak::PTN.new(ptn, board.size)
      @board  = board
      @origin = [@move.x, @move.y]
    end

    def valid?
      return true unless obstructed?
      return false if coordinates.flatten.any? { |n|
        n > @board.size || n < 0
      }

      x, y      = move.position
      top_piece = @board[x][y].last

      if %w(Cw Cb).include?(top_piece)
        x2, y2      = coordinates.last
        obstruction = @board[x2][y2].last

        %w(Sw Sb).include?(obstruction)
      else
        false
      end
    end

    def obstructed?
      !!coordinates.find { |(x,y)| OBSTRUCTIONS.include?(@board[x][y].last) }
    end

    # MOVE
    def coordinates
      x, y  = move.position
      times = move.size.times

      @coordinates ||= case move.direction
      when '+' then times.map { |n| [x,     y + n] }
      when '-' then times.map { |n| [x,     y - n] }
      when '<' then times.map { |n| [x - n, y]     }
      when '>' then times.map { |n| [x + n, y + n] }
      end
    end
  end
end
