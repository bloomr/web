class ProgramController < ApplicationController
  def index
    @campaign = Campaign.find_by_partner_or_default(cookies[:partner])
  end
end
