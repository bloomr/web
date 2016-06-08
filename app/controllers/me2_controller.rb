class Me2Controller < ApplicationController
  before_action :authenticate_user!

  def show
    cookies['id'] = { value: current_user.id, expires: 30.day.from_now }
    render file: 'public/ember.html', layout: false
  end
end
