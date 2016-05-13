require 'rails_helper'

RSpec.describe PartnerController, type: :controller do

  describe 'GET #sujetdubac' do
    before do
      get :sujetdubac
    end

    it 'redirect to bac bloomr org' do
      expect(response).to redirect_to('http://bac.bloomr.org/')
    end

    it 'set the sujetdubac cookie' do
      expect(response.cookies['sujetdubac']).to eq('true')
    end
  end

end
