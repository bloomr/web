require 'rails_helper'

RSpec.describe Mailchimp, type: :model do
  let(:bloomy) { create(:bloomy) }
  describe '#subscribe_to_journey' do
    let(:url) { 'https://us9.api.mailchimp.com/3.0/lists/58fadd9d86/members' }
    let(:ok_response) { double('response', success?: true) }
    let(:ko_response) { double('response', success?: false) }

    let(:headers) do
      { 'Authorization' => 'apikey api',
        'Content-Type' => 'application/json' }
    end

    let(:post_body) { { headers: headers, body: body } }
    before do
      ENV['MAILCHIMP_API_KEY'] = 'api'
    end

    context 'when all the data are set' do
      let(:body) do
        { 'status' => 'subscribed', 'email_address' => bloomy.email,
          'merge_fields' =>
        { 'FNAME' => bloomy.first_name, 'AGE' => bloomy.age } }.to_json
      end

      it 'calls the mailchimp api with all the data' do
        expect(HTTParty).to receive(:post).with(url, post_body)
          .and_return(ok_response)
        Mailchimp.subscribe_to_journey(bloomy)
      end

      it 'raises an exception if mailchimp return a not success answer' do
        expect do
          expect(HTTParty).to receive(:post).with(url, post_body)
            .and_return(ko_response)
          Mailchimp.subscribe_to_journey(bloomy)
        end.to raise_error(RuntimeError)
      end
    end

    context 'when the age is missing' do
      let(:body) do
        { 'status' => 'subscribed', 'email_address' => bloomy.email,
          'merge_fields' =>
        { 'FNAME' => bloomy.first_name } }.to_json
      end

      it 'calls the mailchimp api without the age' do
        expect(HTTParty).to receive(:post).with(url, post_body)
          .and_return(ok_response)
        bloomy.age = nil
        Mailchimp.subscribe_to_journey(bloomy)
      end
    end
  end

  describe '.send_rejoindre_communaute_email' do
    before :each do
      expect(Mailchimp).to receive(:delay).and_return(Mailchimp)
    end

    after :each do
      Mailchimp.send_rejoindre_communaute_email(bloomy, 'toto')
    end

    it 'call send_template with the right params' do
      expect(Mailchimp).to receive(:send_template).with(
        template_name: 'mission-2-rejoindre-la-communaute',
        to_mail: bloomy.email,
        from_name: 'Le parcours Bloomr',
        from_mail: 'hello@bloomr.org',
        subject: '[Mail 2 - Etape 1] Mission #2 : Dis nous qui tu es',
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
