require "spec_helper"


describe Tak::Board do
  describe '.initialize' do
    it 'creates a blank board' do
      board = Tak::Board.new(5)

      expect(board.board.size).to eq(5)
      expect(board.board.first.size).to eq(5)
    end
  end

  describe 'path test' do
    it 'finds a road' do
      board = Tak::Board.new(3)
      board.board = [
        [%w(Cw), %w(b), %w()],
        [%w(w),  %w(w), %w(Cb)],
        [%w(b),  %w(w), %w(b)],
      ]

      expect(board.road_win?(:white)).to be true

      board2 = Tak::Board.new(3)
      board2.board = [
        [%w(b Cw), %w(b),   %w()],
        [%w(w),    %w(b w), %w(w)],
        [%w(b),    %w(w b), %w(b)],
      ]

      expect(board2.road_win?(:white)).to be true

      board3 = Tak::Board.new(3)
      board3.board = [
        [%w(b Cw), %w(b),   %w()],
        [%w(w),    %w(b w), %w()],
        [%w(b),    %w(w b), %w(b)],
      ]

      expect(board3.road_win?(:white)).to be false

      board4 = Tak::Board.new(6)
      board4.board = [
        [%w(w), %w(w), %w(),  %w(),  %w(),  %w()],
        [%w(),  %w(w), %w(w), %w(),  %w(),  %w()],
        [%w(),  %w(),  %w(w), %w(w), %w(),  %w()],
        [%w(),  %w(),  %w(),  %w(w), %w(w), %w()],
        [%w(),  %w(),  %w(),  %w(),  %w(w), %w()],
        [%w(),  %w(),  %w(),  %w(),  %w(b), %w()],
      ]

      expect(board4.road_win?(:white)).to be false

      board5 = Tak::Board.new(8)
      board5.board = [
        [%w(w), %w(w), %w(),  %w(),  %w(),  %w(),  %w(),  %w()],
        [%w(),  %w(w), %w(w), %w(),  %w(),  %w(),  %w(),  %w()],
        [%w(),  %w(),  %w(w), %w(w), %w(),  %w(),  %w(),  %w()],
        [%w(),  %w(),  %w(),  %w(w), %w(w), %w(),  %w(),  %w()],
        [%w(),  %w(),  %w(),  %w(),  %w(w), %w(),  %w(),  %w()],
        [%w(),  %w(),  %w(),  %w(),  %w(w), %w(),  %w(),  %w()],
        [%w(),  %w(),  %w(),  %w(),  %w(w), %w(),  %w(),  %w()],
        [%w(),  %w(),  %w(),  %w(),  %w(w), %w(),  %w(),  %w()],
      ]

      expect(board5.road_win?(:white)).to be true
    end
  end
end
