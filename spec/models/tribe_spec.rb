require 'rails_helper'

RSpec.describe Tribe, :type => :model do
  describe '#before save, store the normalize name' do
    context 'when a new tribe is created' do
      let!(:tribe) { Tribe.create( name: '3.0') }
      it 'normalize name is saved' do
        expect(tribe.normalized_name).to eq('3_0')
      end
    end
  end
end
