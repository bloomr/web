require 'rails_helper'

RSpec.describe TribesController, type: :controller do
  describe 'GET #show' do
    context 'when there is a tribe' do
      let!(:tribe) { Tribe.create(name: 'tiptop') }

      it 'returns http success' do
        get :show, id: 'tiptop'
        expect(response).to have_http_status(:success)
        expect(assigns[:tribe]).to eq(tribe)
      end
    end
  end
end
