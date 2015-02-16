require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :request do

  payload = {
      key: "yop",
      user: {
          email: "yopyop@yop.com",
          job_title: "vendeur_yop",
          first_name: "yop",
          questions_attributes: [
              {
                  identifier: "specifically",
                  title: "Que faites vous exactement ?",
                  answer: "je vends du yop"
              },
              {
                  identifier: "love_job",
                  title: "Au fond, qu'est ce qui fait que vous aimez votre métier ?",
                  answer: "j'adore le yop"
              }
          ],
          keyword_list: "tag1, tag2, tag3"
      }
  }

  ENV["API_KEY"] = "yop"

  describe "POST #users" do
    it "responds unauthorized with an HTTP 401 status code if bad api key" do
      post "api/v1/users", {}, { "Accept" => "application/json" }
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)["error"]).to eq("invalid key")
    end

    it "responds yop with 200 code if creation of user" do
      post "api/v1/users", payload, { "Accept" => "application/json" }
      expect(JSON.parse(response.body)["user_id"]).to eq(1)
      expect(response).to have_http_status(200)
    end

    it "create the user correctly" do
      post "api/v1/users", payload, { "Accept" => "application/json" }
      user = User.find(1)
      expect(user.email).to eq("yopyop@yop.com")
      expect(user.keywords.map{ |k| k.tag }).to eq(["tag1", "tag2", "tag3"])
    end

    it "responds yop with 500 code if users mail is already known" do
      User.create!(
          :email => "yopyop@yop.com",
          :first_name => "John",
          :job_title => "Developer",
          :password => "abcdfedv",
          :published => true)

      post "api/v1/users", payload, { "Accept" => "application/json" }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("creation ko")
    end
  end

end
