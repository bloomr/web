require 'rails_helper'

RSpec.describe Admin::EmailCampaignsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/email_campaigns').to route_to('admin/email_campaigns#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/email_campaigns/new').to route_to('admin/email_campaigns#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/email_campaigns/1').to route_to('admin/email_campaigns#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/email_campaigns').to route_to('admin/email_campaigns#create')
    end
  end
end
