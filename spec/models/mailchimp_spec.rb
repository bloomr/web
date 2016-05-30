require 'rails_helper'

RSpec.describe Mailchimp, type: :model do
  let(:bloomy) { create(:bloomy) }
  describe '#subscribe_to_journey' do
    let(:url) { 'https://us9.api.mailchimp.com/3.0/lists/e6faea0c3a/members' }

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
    before do
      ENV['MAILCHIMP_API_KEY'] = 'api'
    end

    it 'calls the mailchimp api' do
      expect(HTTParty).to receive(:post).with(url, post_body)
      Mailchimp.subscribe_to_journey(bloomy)
    end
  end

  describe '.send_premier_parcours_email' do
    before :each do
      expect(Mailchimp).to receive(:delay).and_return(Mailchimp)
    end

    after :each do
      Mailchimp.send_premier_parcours_email(bloomy, 'toto')
    end

    it 'call send_template with the right params' do
      expect(Mailchimp).to receive(:send_template).with(
        template_name: 'premier-mail-du-parcours',
        to_mail: bloomy.email,
        from_name: 'Le parcours Bloomr',
        from_mail: 'hello@bloomr.org',
        subject: '[Mail 1 - Etape 1] Mission #1 : Dis nous qui tu es',
        vars: {
          first_name: bloomy.first_name.capitalize,
          email: bloomy.email,
          password: 'toto' })
    end
  end

  describe '.send_premier_parcours_email' do
    after :each do
      Mailchimp.send_presentation_email(bloomy)
    end

    it 'call send_template with the right params' do
      expect(Mailchimp).to receive(:send_template).with(
        template_name: 'presentation-du-parcours',
        to_mail: bloomy.email,
        from_name: 'Le parcours Bloomr',
        from_mail: 'hello@bloomr.org',
        subject: 'Bienvenue !',
        vars: {
          first_name: bloomy.first_name.capitalize
        })
    end
  end
end
