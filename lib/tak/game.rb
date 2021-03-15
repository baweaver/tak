module Tak
  class Game
    def initialize(size)
      @tak_board  = Tak::Board.new(size)
      @turn       = :white
      @first_move = true
    end
  end
end
