module Tak
  class Move
    attr_reader :move
    attr_reader :origin

    OBSTRUCTIONS = %w(Cw Cb Sw Sb)

    def initialize(ptn, tak_board)
      @move   = Tak::PTN.new(ptn, tak_board.size)
      @board  = tak_board.board
      @origin = [@move.x, @move.y]
    end

    def type
      move.type
    end

    def piece
      move.piece
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

    def coordinates
      x, y  = move.position
      times = move.size.times

      return [[x,y]] if move.size.zero?

      case move.direction
      when '+' then times.map { |n| [x,     y + n] }
      when '-' then times.map { |n| [x,     y - n] }
      when '<' then times.map { |n| [x - n, y]     }
      when '>' then times.map { |n| [x + n, y + n] }
      end
    end
  end
end
