require 'rails_helper'

RSpec.describe Mailchimp, type: :model do
  describe '#subscribe_to_journey' do
    let(:url) { 'https://us9.api.mailchimp.com/3.0/lists/9ec70e12ca/members' }

    let(:headers) do
      { 'Authorization' => 'apikey api',
        'Content-Type' => 'application/json' }
    end

    let(:body) do
      { 'status' => 'subscribed', 'email_address' => bloomy.email,
        'merge_fields' =>
      { 'FNAME' => bloomy.first_name, 'MMERGE3' => bloomy.age } }.to_json
    end

    let(:post_body) { { headers: headers, body: body } }
    let(:bloomy) { create(:bloomy) }
    before do
      ENV['MAILCHIMP_API_KEY'] = 'api'
    end

    context 'when mailchimp option is activated' do
      before :each do
        ENV['MAILCHIMP_ACTIVATED'] = 'true'
      end

      it 'calls the mailchimp api' do
        expect(HTTParty).to receive(:post).with(url, post_body)
        Mailchimp.subscribe_to_journey(bloomy)
      end
    end

    context 'when mailchimp option is not activated' do
      before :each do
        ENV['MAILCHIMP_ACTIVATED'] = nil
      end

      it 'calls the mailchimp api' do
        expect(HTTParty).to receive(:post).with(any_args).exactly(0).times
        Mailchimp.subscribe_to_journey(bloomy)
      end
    end
  end
end
