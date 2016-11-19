require_relative '../requires'

describe Taco do
  subject(:taco) { Taco.new }

  describe 'eating' do
    it 'eats' do
      subject.eat

      expect(subject.full?).to be true
    end
  end
end
