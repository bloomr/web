class PartnerController < ApplicationController

  def set_campaign
    campaign = Campaign.find_by_partner(params[:name])
    return redirect_to root_path if campaign.nil?
    cookies['partner'] = { value: params[:name], expires: 30.day.from_now }
    redirect_to campaign.campaign_url
  end

end
