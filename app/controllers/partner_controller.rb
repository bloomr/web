class PartnerController < ApplicationController

  def sujetdubac
    cookies[:sujetdubac] = { value: true, expires: 30.day.from_now }
    redirect_to 'http://bac.bloomr.org/'
  end
end
