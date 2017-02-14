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

    def flat_counts
      count_hash = Hash.new { |h,k| h[k] = 0 }

      @board.each_with_object(count_hash) do |row, counts|
        row.each do |cell|
          counts[:white] += 1 if cell.last == 'w'
          counts[:black] += 1 if cell.last == 'b'
        end
      end
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

    def path_search(x, y, direction, bit_board, traversed = visited_board)
      return false if out_of_bounds(x,y) || traversed[x][y]

      piece_value = bit_board[x][y]
      return false if (piece_value == 0)

      horizontal_end = direction == :horizontal && x == @size - 1
      vertical_end   = direction == :vertical   && y == @size - 1
      neutral_end    = direction.nil? && [x,y].include?(@size - 1)

      if horizontal_end || vertical_end || neutral_end
        true
      else
        traversed[x][y] = true

        path_search(x + 1, y,     direction, bit_board, traversed) ||
        path_search(x - 1, y,     direction, bit_board, traversed) ||
        path_search(x,     y + 1, direction, bit_board, traversed) ||
        path_search(x,     y - 1, direction, bit_board, traversed)
      end
    end

    def visited_board
      Array.new(@size) { Array.new(@size, false) }
    end

    def move!(ptn)
      move = Tak::Move.new(ptn, size)

      return false unless move.valid?

      case move.type
      when 'movement'  then distribute_pieces(move)
      when 'placement' then place_piece(move)
      end
    end

    def distribute_pieces(move)
      x, y  = move.origin
      stack = @board[x][y].pop(move.size)

      move.coordinates.each do |(x, y)|
        @board[x][y].push(stack.pop)
      end
    end

    # MOVE
    def place_piece(move)
      x, y  = move.origin

      return false unless @board[x][y].empty?

      @board[x][y].push(move.piece)
    end

    private

    def generate_board(ptn)
      return Array.new(size) { Array.new(size) } unless ptn
    end
  end
end
