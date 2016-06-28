require 'rails_helper'

RSpec.describe TagController, type: :controller do
  context 'when a tag is unknown' do
    it 'raises a 404' do
      expect do
        get :show, id: 'unknown_tag'
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
