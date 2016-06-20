class Me2Controller < ApplicationController
  before_action :authenticate_user!

  def show
    render file: 'public/ember.html', layout: false
  end
end
