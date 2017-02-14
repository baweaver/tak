module Tak
  class PieceSet
    attr_reader :flats, :capstones

    # https://en.wikipedia.org/wiki/Tak_(game)#Rules
    #
    # 21 pieces is correct for 5s
    #
    # size => [pieces, capstones]
    PIECE_TOTALS = {
      3 => [10, 0],
      4 => [15, 0],
      5 => [21, 1],
      6 => [30, 1],
      7 => [40, 2],
      8 => [50, 2]
    }

    def initialize(board_size: 5, flats: nil, capstones: nil)
      default_flats, default_capstones = PIECE_TOTALS[board_size]

      @flats     = flats || default_flats
      @capstones = capstones || default_capstones

      @pieces = {
        capstone:  @capstones,
        flatstone: @flats
      }
    end

    # Whether or not the set is empty
    #
    # @note It's often forgotten rule that a capstone needs to be played to
    #       consider a piece set as empty and trigger a flat win count.
    #
    # @return [Boolean]
    def empty?
      @capstones + @flats == 0
    end

    # Removes a piece from a set
    #
    # @param type [Symbol] Type of piece
    #
    # @return [Boolean] Whether the removal was valid
    def remove(type)
      return false if @pieces[type] - 1 < 0

      if type == :capstone
        @capstones -= 1
      else
        @flats -= 1
      end

      true
    end
  end
end
