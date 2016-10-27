module Admin
  class EmailCampaignsController < ApplicationController
    before_action :set_admin_email_campaign, only: [:show]
    before_action :authenticate_admin_user!

    def index
      @admin_email_campaigns = Admin::EmailCampaign.all
    end

    def show
    end

    def new
      @admin_email_campaign = Admin::EmailCampaign.new
    end

    def create
      @admin_email_campaign = Admin::EmailCampaign.new(admin_email_campaign_params)

      if @admin_email_campaign.save
        @admin_email_campaign.delay.process_campaign
        redirect_to @admin_email_campaign, notice: 'Email campaign was successfully created.'
      else
        render :new
      end
    end

    private

    def set_admin_email_campaign
      @admin_email_campaign = Admin::EmailCampaign.find(params[:id])
    end

    def admin_email_campaign_params
      params.require(:admin_email_campaign).permit(:template_name, :var1_name, :var1_value, :var2_name, :var2_value, :var3_name, :var3_value, :recipients, :published_bloomeurs, :terminated, :logs)
    end
  end
end
