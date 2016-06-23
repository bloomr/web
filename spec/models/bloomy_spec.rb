require 'rails_helper'

RSpec.describe Bloomy, type: :model do
  let(:bloomy) do
    Bloomy.new(email: 'toto@to.com', first_name: 'toto',
               password: 'totototototo')
  end

  it 'can be saved without a first_name' do
    bloomy.first_name = nil
    expect(bloomy.save).to be(false)
  end

  it 'is saved otherwise' do
    expect(bloomy.save).to be(true)
  end
end
