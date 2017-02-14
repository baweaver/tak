module Tak
  class Board
    attr_accessor :size
    attr_accessor :board

    attr_reader :white_piece_set
    attr_reader :black_piece_set

    # What constitutes a road-forming piece
    ROAD = {
      white: %w(w Cw),
      black: %w(b Cb)
    }

    # Creates a new Tak Board
    #
    # @param size [Integer]       Size of the board
    # @param ptn  [Array[String]] Previous game moveset to reconstruct from
    def initialize(size, ptn = nil)
      @size  = size
      @board = generate_board(ptn)

      @white_piece_set = Tak::PieceSet.new(board_size: size)
      @black_piece_set = Tak::PieceSet.new(board_size: size)

      @piece_sets = {
        white: white_piece_set, black: black_piece_set
      }
    end

    # Gets the current visible flat counts on the board
    #
    # @return [Hash[Symbol, Integer]]
    def flat_counts
      count_hash = Hash.new { |h,k| h[k] = 0 }

      @board.each_with_object(count_hash) do |row, counts|
        row.each do |cell|
          counts[:white] += 1 if cell.last == 'w'
          counts[:black] += 1 if cell.last == 'b'
        end
      end
    end

    def empty_piece_set?
      @piece_sets.any? { |c, piece_set| piece_set.empty? }
    end

    # Returns who the flat winner is, or false if there is none yet
    #
    # Not a fan of the Bool/Sym response, consider refactor later.
    #
    # @return [Boolean || Symbol]
    def flat_winner
      return false unless empty_piece_set?

      white_flats, black_flats = flat_counts.values
      case white_flats <=> black_flats
      when  0 then :tie
      when  1 then :white
      when -1 then :black
      end
    end

    # Converts the current board into a bit variant in which viable
    # road pieces for `color` are represented as 1s
    #
    # @param color [Symbol]
    #
    # @return [Array[Array[Integer]]]
    def bit_board(color)
      @board.map { |row|
        row.map { |cell| ROAD[color].include?(cell.last) ? 1 : 0 }
      }
    end

    # Checks if a road win for `color` is present
    #
    # @param color [Symbol] Color to check for a win
    #
    # @return [Boolean]
    def road_win?(color)
      current_bit_board = bit_board(color)

      # Begin traversing through the board for potential roads.
      path_search(0, 0, nil, current_bit_board) || !!@size.times.find { |n|
        path_search(1, n, :horizontal, current_bit_board) ||
        path_search(n, 1, :vertical, current_bit_board)
      }
    end

    def square_owner(x, y)
      return true if @board[x][y].empty?

      @board[x][y].last == 'b' ? :black : :white
    end

    def pieces_at(x, y)
      @board[x][y]
    end

    def move!(ptn, color)
      move = Tak::Move.new(ptn, self, color)

      return false unless move.valid? && square_owner(*move.origin)

      case move.type
      when 'movement'
        distribute_pieces(move)
      when 'placement'
        place_piece(move, color)
      end
    end

    def distribute_pieces(move)
      stack = pieces_at(*move.origin).pop(move.size)

      move.coordinates.each do |(x, y)|
        @board[x][y].push(stack.pop)
      end
    end

    def place_piece(move, color)
      square = pieces_at(*move.origin)

      return false unless square.empty? && @piece_sets[color].remove(move.piece_type)

      square.push(move.piece)

      true
    end

    # Consider moving this all out into a board formatter later. It'd be cleaner.
    #
    # May Matz forgive me for my debugging code here.
    def to_s
      max_size = board.flatten(1).max.join(' ').size + 1

      counts = flat_counts.map { |c, i|
        set = @piece_sets[c]
        "#{c}: #{i} flats, #{set.flats} remaining pieces, #{set.capstones} remaining capstones"
      }.join("\n")

      board_state = board.map.with_index { |row, i|
        row_head = "  #{size - i} "

        row_head + row.reverse.map { |cell|
          "[%#{max_size}s]" % cell.join(' ')
        }.join(' ')
      }.join("\n")

      footer = ('a'..'h').take(size).map { |c| "%#{max_size + 2}s" % c }.join(' ')

      "#{counts}\n\n#{board_state}\n   #{footer}"
    end

    private

    # Checks whether a given coordinate pair is out of bounds
    #
    # @param x [Integer]
    # @param y [Integer]
    #
    # @return [Boolean]
    def out_of_bounds?(x,y)
      x < 0 || y < 0 || x > @size - 1 || y > @size - 1
    end

    # Does a DFS variant to locate a potential road.
    #
    # @param x         [Integer] Start X coordinate
    # @param y         [Integer] Start Y coordinate
    # @param direction [Symbol]  Direction the search completes on
    #
    # @param bit_board [Array[Array[Integer]]] Board to parse against
    # @param traversed [Array[Array[Boolean]]] Traversal tracker
    #
    # @return [Boolean] Whether or not a road was round
    def path_search(x, y, direction, bit_board, traversed = visited_board)
      return false if out_of_bounds?(x,y) || traversed[x][y]

      piece_value = bit_board[x][y]
      return false if piece_value == 0 # Non-road piece
      return true  if road_end?(direction, x, y)

      traversed[x][y] = true

      # Recurse in all four directions. While this may retrace steps it is
      # necessary as roads in Tak can curve wildly.
      path_search(x + 1, y,     direction, bit_board, traversed) ||
      path_search(x - 1, y,     direction, bit_board, traversed) ||
      path_search(x,     y + 1, direction, bit_board, traversed) ||
      path_search(x,     y - 1, direction, bit_board, traversed)
    end

    # Checks to see if a given x y coordinate pair is counted as a road win
    # by being on the appropriate opposite end from the starting direction
    # of the road.
    #
    # @param direction [Symbol]  Starting direction of the road
    # @param x         [Integer]
    # @param y         [Integer]
    #
    # @return [Boolean]
    def road_end?(direction, x, y)
      case direction
      when :horizontal
        x == @size - 1
      when :vertical
        y == @size - 1
      else
        x == @size - 1 || y == @size - 1
      end
    end

    # Creates a board to mark previous traversals of the path search
    #
    # @return [Array[Array[Boolean]]]
    def visited_board
      Array.new(@size) { Array.new(@size, false) }
    end

    def generate_board(ptn)
      return Array.new(size) { Array.new(size) } unless ptn
    end
  end
end
