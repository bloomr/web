require 'rails_helper'

RSpec.describe TagController, type: :controller do
  describe '.show' do
    context 'when a tag is unknown' do
      it 'raises a 404' do
        expect do
          get :show, normalized_tag: 'unknown_tag'
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context 'when a tag is known' do
      let!(:tag) { Keyword.create(tag: 'Capital') }
      before :each do
        get :show, normalized_tag: 'capital'
      end

      it 'returns it' do
        expect(response.status).to eq(200)
      end
    end
  end
end
