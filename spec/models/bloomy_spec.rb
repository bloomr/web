require 'rails_helper'

RSpec.describe Bloomy, type: :model do
  let(:bloomy) do
    Bloomy.new(email: 'toto@to.com', first_name: 'toto',
               password: 'totototototo')
  end

  it 'can not be saved without a first_name' do
    bloomy.first_name = nil
    expect(bloomy.save).to be(false)
  end

  it 'is saved otherwise' do
    expect(bloomy.save).to be(true)
  end

  describe 'an old bloomy with no first_name' do
    let(:old_bloomy) do
      bloomy.save!
      bloomy.first_name = nil
      bloomy.save!
      bloomy.reload
    end

    it 'can change its password' do
      old_bloomy.password = 'tatatatatata'
      expect(old_bloomy.save).to be(true)
    end
  end
end
