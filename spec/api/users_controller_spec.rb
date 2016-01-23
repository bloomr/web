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
    before do
      post "/api/v1/users", my_payload, { "Accept" => "application/json" }
    end
    let(:body) { JSON.parse(response.body) }
    subject { response }

    context 'when there is no api key' do
      let(:my_payload) { {} }

      it { is_expected.to have_http_status(401) }
      it "returns an error invalid key" do
        expect(body["error"]).to eq("invalid key")
      end

    end

    context 'api key is correct' do
      let(:my_payload) { payload }
      
      it { is_expected.to have_http_status(200) }
      it { expect(body['user_id']).to eq(1) }

      describe 'created user' do
        subject { User.find(1) }
        it { expect(subject.email).to eq('yopyop@yop.com') }
        it { expect(subject.keywords.map(&:tag)).to match_array(['tag1', 'tag2', 'tag3']) }
      end

   end

  end

  describe 'post with a existing user' do
    let!(:existing_user) { create(:user, email: 'yopyop@yop.com') }

    before do
      post "/api/v1/users", payload, { "Accept" => "application/json" }
    end

    subject { response }
    let(:body) { JSON.parse(response.body) }

    it { is_expected.to have_http_status(400) }
    it { expect(body['error']).to eq('creation ko') }

  end

  describe "Patch #user" do

    question = {
        key: "yop",
        user: {
            questions_attributes: [
                {
                    identifier: "a",
                    title: "Que faites vous exactement ?",
                    answer: "je vends du yop",
                    published: true
                },
                {
                    identifier: "b",
                    title: "Au fond, qu'est ce qui fait que vous aimez votre métier ?",
                    answer: "j'adore le yop",
                    published: true
                }
            ]
        }
    }

    it "add correctly some questions" do


      user = User.create!(
          :email => "yopyop@yop.com",
          :first_name => "John",
          :job_title => "Developer",
          :password => "abcdfedv",
          :published => true)


      patch "/api/v1/users/" + user.id.to_s, question, { "Accept" => "application/json" }
      user = User.find(1)
      expect(user.questions.length).to eq(2)
      expect(user.questions.map{ |k| k.identifier }).to eq(["a", "b"])
      expect(user.questions.all?{ |q| q.published }).to eq(true)
    end

    it "responds yop with 400 code if users questions is already known" do
      user = User.create!(
          :email => "yopyop@yop.com",
          :first_name => "John",
          :job_title => "Developer",
          :password => "abcdfedv",
          :questions => [
              Question.new(
                  identifier: "a",
                  title: "Que faites vous exactement ?",
                  answer: "je vends du yop"
              ),
              Question.new(
                  identifier: "b",
                  title: "Au fond, qu'est ce qui fait que vous aimez votre métier ?",
                  answer: "j'adore le yop"
              )
          ],
          :published => true)

      patch "/api/v1/users/" + user.id.to_s, question, { "Accept" => "application/json" }
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)["error"]).to eq("update ko")
    end

  end

end
