require "spec_helper"

describe Tak do
  describe PTN do
    it 'creates a PTN class' do
      expect(Tak::PTN.new('d1')).to be_a(Tak::PTN)
    end
  end
end
