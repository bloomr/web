class MeController < ApplicationController
  before_action :authenticate_user!, except: :email_sent

  def show
    render file: 'public/ember.html', layout: false
  end

  def email_sent
  end
end
