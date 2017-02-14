require "spec_helper"


describe Tak::Board do
  let(:tak_board) {
    Tak::Board.new(board_size).tap { |b| b.board = board }
  }

  describe '.initialize' do
    it 'creates a blank board' do
      board = Tak::Board.new(5)

      expect(board.board.size).to eq(5)
      expect(board.board.first.size).to eq(5)
    end
  end

  describe 'flat_counts' do
    let(:board_size) { 3 }
    let(:board) {
      [
        [%w(w), %w(b), %w()],
        [%w(),  %w(),  %w()],
        [%w(),  %w(w), %w(b)],
      ]
    }

    it 'will return the count of "visible" flats' do
      expect(tak_board.flat_counts).to eq({
        white: 2, black: 2
      })
    end
  end

  describe 'road_win?' do
    context 'When a win is present for white' do
      let(:board_size) { 3 }
      let(:board) {
        [
          [%w(w), %w(b), %w()],
          [%w(w), %w(w), %w(b)],
          [%w(b), %w(w), %w(b)],
        ]
      }

      it 'recognizes the white win' do
        expect(tak_board.road_win?(:white)).to be true
      end
    end

    context 'When a win is present for white on a large complicated board' do
      let(:board_size) { 8 }
      let(:board) {
        [
          [%w(w), %w(w),  %w(),   %w(),   %w(),   %w(),   %w(),  %w()],
          [%w(),  %w(Cw), %w(w),  %w(),   %w(),   %w(),   %w(),  %w()],
          [%w(),  %w(b),  %w(w),  %w(w),  %w(),   %w(),   %w(),  %w()],
          [%w(b), %w(),   %w(Cb), %w(w),  %w(w),  %w(Sb), %w(),  %w()],
          [%w(),  %w(),   %w(),   %w(Sb), %w(w),  %w(),   %w(),  %w()],
          [%w(b), %w(),   %w(),   %w(),   %w(w),  %w(w),  %w(),  %w()],
          [%w(),  %w(),   %w(),   %w(),   %w(Sb), %w(w),  %w(w), %w()],
          [%w(b), %w(),   %w(),   %w(),   %w(w),  %w(Sb), %w(w), %w()],
        ]
      }

      it 'recognizes the white win' do
        expect(tak_board.road_win?(:white)).to be true
      end
    end

    context 'When a white road is not present' do
      let(:board_size) { 3 }
      let(:board) {
        [
          [%w(w), %w(b), %w()],
          [%w(w), %w(w), %w(b)],
          [%w(b), %w(),  %w(b)],
        ]
      }

      it 'will not recognize a white winner' do
        expect(tak_board.road_win?(:white)).to be false
      end
    end

    context 'When a black win is present and a white win is being checked for' do
      let(:board_size) { 3 }
      let(:board) {
        [
          [%w(w), %w(b), %w()],
          [%w(w), %w(w), %w(b)],
          [%w(b), %w(b), %w(b)],
        ]
      }

      it 'will not recognize a white winner' do
        expect(tak_board.road_win?(:white)).to be false
      end

      it 'will recognize a black winner when asked' do
        expect(tak_board.road_win?(:black)).to be true
      end
    end
  end
end
