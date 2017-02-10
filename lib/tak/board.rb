module Tak
  class Board
    attr_accessor :size
    attr_accessor :board

    ROAD = {
      white: %w(w Cw),
      black: %w(b Cb)
    }

    def initialize(size, ptn = nil)
      @size = size
      @board = generate_board(ptn)
    end

    def road_win?(color)
      bit_board = @board.map { |row|
        row.map { |cell| ROAD[color].include?(cell.last) ? 1 : 0 }
      }

      path_search(0, 0, nil, bit_board) || !!@size.times.find { |n|
        path_search(1, n, :horizontal, bit_board) ||
        path_search(n, 1, :vertical, bit_board)
      }
    end

    def out_of_bounds(x,y)
      x < 0 || y < 0 || x > @size - 1 || y > @size - 1
    end

    def path_search(x, y, direction, bit_board, traversed = {})
      return false if (out_of_bounds(x,y) || traversed["#{x}:#{y}"])

      piece_value = bit_board[x][y]
      return false if (piece_value == 0)

      horizontal_end = direction == :horizontal && x == @size - 1
      vertical_end   = direction == :vertical   && y == @size - 1
      neutral_end    = direction.nil? && [x,y].include?(@size - 1)

      if horizontal_end || vertical_end || neutral_end
        true
      else
        new_traversed = {"#{x}:#{y}" => true}.merge! traversed

        path_search(x + 1, y,     direction, bit_board, new_traversed) ||
        path_search(x - 1, y,     direction, bit_board, new_traversed) ||
        path_search(x,     y + 1, direction, bit_board, new_traversed) ||
        path_search(x,     y - 1, direction, bit_board, new_traversed)
      end
    end

    def move!(ptn)
      move = Tak::PTN.new(ptn)

      return false unless move.valid?

      case move.type
      when 'movement'  then distribute_pieces(move)
      when 'placement' then place_piece(move)
      end
    end

    def place_piece(move)
      return false unless head_piece(move.x, move.y) == 'empty'

      @board[move.x][move.y].push(move.piece)
    end

    def head_piece(x, y)
      case @board[x][y].last
      when /C/ then 'capstone'
      when /S/ then 'wall'
      when /./ then 'flat'
      else          'empty'
      end
    end

    private

    def generate_board(ptn)
      return Array.new(size) { Array.new(size) } unless ptn
    end
  end
end
