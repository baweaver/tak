require "spec_helper"

describe Tak do
  describe Tak::PieceSet do
    describe '#remove' do
      context 'When the set has pieces left' do
        let(:piece_set) { Tak::PieceSet.new(flats: 21, capstones: 1) }

        it 'decrements the type and returns true' do
          expect(piece_set.remove(:capstone)).to eq(true)
          expect(piece_set.capstones).to eq(0)
        end
      end

      context 'When the set does not have pieces' do
        let(:piece_set) { Tak::PieceSet.new(flats: 21, capstones: 0) }

        it 'returns false' do
          expect(piece_set.remove(:capstone)).to eq(false)
        end
      end
    end

    describe '#empty?' do
      it 'returns true when the set is empty' do
        expect(Tak::PieceSet.new(flats: 0, capstones: 0).empty?).to eq(true)
      end

      it 'returns false when the set is not empty' do
        expect(Tak::PieceSet.new(flats: 0, capstones: 1).empty?).to eq(false)
      end
    end
  end
end
