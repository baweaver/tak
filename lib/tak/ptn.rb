module Tak
  class PTN
    NOTATION_REGEX = /(?<number>\d+)?(?<special_piece>[CS])?(?<position>[a-h][1-8])((?<direction>[<>+-])(?<stack>\d+)?)?/i

    attr_reader :errors, :ptn_match

    def initialize(notation, board_size = 5)
      @ptn_match  = NOTATION_REGEX.match(notation)
      @board_size = board_size

      if @ptn_match
        @number        = @ptn_match[:number]
        @special_piece = @ptn_match[:special_piece]
        @position      = @ptn_match[:position]
        @direction     = @ptn_match[:direction]
        @stack         = @ptn_match[:stack]
      end

      @errors = []
    end

    def stack_total
      @stack_total ||= @stack ? @stack.chars.reduce(0) { |a, s| a + s.to_i } : 0
    end

    def error(msg)
      @errors << msg
    end

    # Placement of a special piece (Capstone or Standing) cannot also be a move
    def movement_and_placement?
      !!(@special_piece && @number || @direction || @stack)
    end

    def over_stack?
      stack_total > (@number.to_i || 0)
    end

    def under_stack?
      stack_total < (@number.to_i || 0)
    end

    def above_handsize?
      stack_total > @board_size || (@number.to_i || 0) > @board_size
    end

    def out_of_bounds?
      x, y = @position.chars

      ('a'..'h').to_a.index(x) + 1 > @board_size || y.to_i > @board_size
    end

    def distrubutes_out_of_bounds?
      x, y = @position.chars

      ('a'..'h').to_a.index(x) + 1 + stack_total > @board_size ||
      y.to_i + stack_total > @board_size
    end

    def valid?
      @valid ||= begin
        # Break before we do anything else here.
        error 'Did not match PTN Format' and return false unless @ptn_match

        error 'Cannot move more pieces than the board size!'      if above_handsize?
        error 'Cannot distribute more pieces than were picked up' if over_stack?
        error 'Cannot distribute less pieces than were picked up' if under_stack?
        error 'Cannot move and place a piece'                     if movement_and_placement?
        error 'Cannot place or move a piece out of bounds'        if out_of_bounds?

        @errors.none?
      end
    end
  end
end
