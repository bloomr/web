require 'rails_helper'

RSpec.describe Api::V1::MeController, type: :request do
  include Warden::Test::Helpers

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/vnd.api+json',
      'ACCEPT' => 'application/vnd.api+json'
    }
  end

  let(:body) { JSON.parse(response.body) }
  let(:tribe1) { Tribe.create(name: 'tribe1', description: 'description') }
  let(:challenge1) { Challenge.create(name: 'challenge1') }
  let(:keyword1) { Keyword.create(tag: 'keyword1') }
  let(:strength1) { Strength.create(name: 'strength1') }

  let(:user) do
    user = create(:user_published_with_questions,
                  tribes: [tribe1],
                  challenges: [challenge1],
                  keywords: [keyword1],
                  strengths: [strength1])
    user
  end
  subject { response }

  describe 'GET me #show' do
    before :each do
      Warden.test_mode!
      login_as(user, scope: :user)
      get '/api/v1/me', headers: headers
    end

    it { is_expected.to have_http_status(:success) }

    it 'send the right attributes' do
      keys = body['data']['attributes'].keys
      expected_keys = %w(job-title first-name stats avatar-url do-authorize)
      expect(keys).to match(expected_keys)
    end

    def expect_includes_relation(relation, hashes)
      relation_datas = body['included'].select { |i| i['type'] == relation }

      expect(relation_datas.count).to eq(hashes.count)

      expect(relation_datas[0]['attributes']).to eq(hashes[0])
    end

    it 'includes the tribe relation' do
      hash = {
        'name' => 'tribe1',
        'description' => 'description',
        'normalized-name' => 'tribe1'
      }
      expect_includes_relation('tribes', [hash])
    end

    it 'includes the questions relation' do
      hash = {
        'answer' => 'answer',
        'description' => nil,
        'step' => nil,
        'title' => 'title',
        'mandatory' => false
      }
      expect_includes_relation('questions', [hash, hash])
    end

    it 'includes the challenges relation' do
      hash = { 'name' => 'challenge1' }
      expect_includes_relation('challenges', [hash])
    end

    it 'includes the keywords relation' do
      hash = { 'tag' => 'keyword1' }
      expect_includes_relation('keywords', [hash])
    end

    it 'includes the strengths relation' do
      hash = { 'name' => 'strength1' }
      expect_includes_relation('strengths', [hash])
    end
  end

  describe 'POST me #photo' do
    let(:user) { create(:user_published_with_questions) }

    before :each do
      Warden.test_mode!
      login_as(user, scope: :user)
    end

    it 'saves the new photo and return the new avatar url' do
      expect(user).to receive(:avatar=).with('binary_photo')
      avatar_double = double('avatar', url: 'toto.png')
      expect(user).to receive(:avatar).and_return(avatar_double)
      expect(user).to receive(:save).twice # dont know ...

      post '/api/v1/me/photo', params: { avatar: 'binary_photo' }

      expect(body['avatarUrl']).to eq('toto.png')
    end
  end
end
