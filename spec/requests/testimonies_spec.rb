require 'rails_helper'

RSpec.describe "Testimonies", type: :request do
  describe "GET /testimonies" do
    it "works! (now write some real specs)" do
      get testimonies_path
      expect(response).to have_http_status(200)
    end
  end
end
