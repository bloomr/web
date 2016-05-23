class PartnerController < ApplicationController

  def set_campaign
    if params[:name] != nil then
      cookies['partner'] = { value: params[:name], expires: 30.day.from_now }
      campaign = Campaign.find_by_partner(params[:name])
      redirect_to campaign.campaign_url
    end
  end

end
