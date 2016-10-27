require 'rails_helper'

RSpec.describe Admin::EmailCampaign, type: :model do
  let(:email_campaign) { Admin::EmailCampaign.new }
  let(:user) { create(:user_published_with_questions) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user_published_with_questions) }

  describe 'build_recipients' do
    describe 'with no users' do
      it 'is empty' do
        expect(email_campaign.build_recipients).to match([])
      end
    end

    describe 'with 2 recipient' do
      before :each do
        email_campaign.recipients = user.email + ', ' + user2.email
      end
      it 'matches the recipients' do
        expect(email_campaign.build_recipients).to match([user, user2])
      end
    end

    describe 'with published_bloomeurs options' do
      before :each do
        email_campaign.published_bloomeurs = true
      end

      it 'matches all the published bloomeurs' do
        expect(email_campaign.build_recipients).to match([user, user3])
      end
    end
  end

  describe 'build_options' do
    describe 'with 2 value/name set' do
      let(:result) { email_campaign.build_options(user)[:vars] }
      before :each do
        email_campaign.var1_name = '1_name'
        email_campaign.var1_value = 'first_name'
        email_campaign.var2_name = ''
        email_campaign.var2_value = ''
        email_campaign.var3_name = '3_name'
        email_campaign.var3_value = 'job_title'
      end

      it 'assigns the value name' do
        expect(result).to eq('1_name': user.first_name, '3_name': user.job_title)
      end
    end
  end

  describe 'initializes logs' do
    let(:result) { email_campaign.logs }
    describe 'when logs is empty' do
      it 'initializes logs' do
        expect(result).to eq('errors' => [], 'success' => [])
      end
    end

    describe 'when logs is full' do
      let(:h) { { 'errors' => [{ 'id' => 1 }], 'success' => [{ 'id' => 2 }] } }

      before :each do
        email_campaign.logs = h
        email_campaign.save
      end

      it 'initializes logs' do
        expect(Admin::EmailCampaign.find(email_campaign.id).logs).to eq(h)
      end
    end
  end

  describe 'process_campaign' do
    let(:success) { email_campaign.logs['success'] }
    let(:errors) { email_campaign.logs['errors'] }

    describe 'with one user' do
      before :each do
        expect(email_campaign).to receive(:build_recipients).and_return([user])
        expect(email_campaign).to receive(:save).twice
      end

      describe 'and mailchimp ok' do
        before :each do
          expect(Mailchimp).to receive(:send_template)
          email_campaign.process_campaign
        end

        it 'logs one success' do
          expect(errors).to match([])
          expect(success).to match([{ 'id' => user.id }])
        end

        it 's state is finished' do
          expect(email_campaign.finished).to be(true)
        end
      end

      describe 'and mailchimp ko' do
        before :each do
          expect(Mailchimp).to receive(:send_template)
            .and_throw(StandardError.new('nop'))
          email_campaign.process_campaign
        end

        it 'logs one error' do
          expect(errors).to match(
            [{ 'id' => 1,
               'message' => 'uncaught throw #<StandardError: nop>' }]
          )
          expect(success).to match([])
        end
      end
    end
  end
end
