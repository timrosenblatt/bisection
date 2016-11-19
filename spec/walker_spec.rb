require_relative '../requires'

describe Walker do
  subject(:walker) { Walker.new dogs }

  describe 'walking the dogs' do
    let(:dogs) { [ dog ] }
    let(:dog) { double('dog') }

    context 'with one dog' do
      it 'works' do
        expect(dog).to receive :walk

        subject.walk_dogs
      end
    end

    context 'with two dogs' do
      let(:dog2) { double 'second dog' }
      let(:dogs) { [dog, dog2] }

      it 'works with multiple dogs' do
        expect(dog).to receive :walk
        expect(dog2).to receive :walk

        subject.walk_dogs
      end
    end

    context 'with a real dog' do
      let(:dog) { Lala.new }

      it 'works' do
        expect { subject.walk_dogs }.to_not raise_error
      end
    end
  end
end
