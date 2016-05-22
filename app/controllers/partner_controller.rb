class PartnerController < ApplicationController

  def show_campaign
    cookies[params[:name]] = { value: true, expires: 30.day.from_now }
    campaign = Campaign.find_by_partner(params[:name])
    redirect_to campaign.campaign_url
  end

  def sujetdubac
    cookies[:sujetdubac] = { value: true, expires: 30.day.from_now }
    redirect_to 'http://bac.bloomr.org/'
  end
end
