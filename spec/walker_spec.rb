require_relative '../requires'

describe Walker do
  describe 'walking the dogs' do
    it 'works with one dog' do
      dog = double
      expect(dog).to receive :walk

      Walker.new([dog]).walk_dogs
    end

    it 'works with multiple dogs' do
      first_dog = double
      second_dog = double

      expect(first_dog).to receive :walk
      expect(second_dog).to receive :walk

      Walker.new([first_dog, second_dog]).walk_dogs
    end
  end
end
