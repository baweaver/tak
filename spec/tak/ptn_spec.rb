require "spec_helper"

describe Tak do
  describe Tak::PTN do
    it 'creates a PTN class' do
      expect(Tak::PTN.new('d1')).to be_a(Tak::PTN)
    end

    describe 'coordinates' do
      it 'has an x coordinate' do
        expect(Tak::PTN.new('d5').x).to eq(4)
      end

      it 'has a y coordinate' do
        expect(Tak::PTN.new('d5').y).to eq(3)
      end
    end

    describe 'validations' do
      it 'will fail invalid PTN' do
        ptn = Tak::PTN.new('foobar')

        expect(ptn.valid?).to eq(false)
        expect(ptn.errors).not_to be_empty
      end

      it 'will fail when attempting to move over the hand size of the board' do
        ptn = Tak::PTN.new('5d5', 4)

        expect(ptn.valid?).to eq(false)
        expect(ptn.errors).not_to be_empty
        expect(ptn.errors).to include('Cannot move more pieces than the board size!')
      end

      it 'will fail if you try and distribute more pieces than you picked up' do
        ptn = Tak::PTN.new('5d5-455')

        expect(ptn.valid?).to eq(false)
        expect(ptn.errors).not_to be_empty
        expect(ptn.errors).to include('Cannot distribute more pieces than were picked up')
      end

      it 'will fail if you try and move and place at the same time' do
        ptn = Tak::PTN.new('5Cd5-4')

        expect(ptn.valid?).to eq(false)
        expect(ptn.errors).not_to be_empty
        expect(ptn.errors).to include('Cannot move and place a piece')
      end

      it 'will fail if the stack distributes out of bounds' do
        ptn = Tak::PTN.new('5d5+11111')

        expect(ptn.valid?).to eq(false)
        expect(ptn.errors).not_to be_empty
        expect(ptn.errors).to include('Cannot distribute pieces out of bounds')
      end

      it 'will fail if the stack total and number of pieces to move are not equal' do
        ptn = Tak::PTN.new('5d5-4')

        expect(ptn.valid?).to eq(false)
        expect(ptn.errors).not_to be_empty
        # expect(ptn.errors).to include()
      end
    end
  end
end
