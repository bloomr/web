class Me2Controller < ApplicationController
  def show
    render file: 'public/ember.html', layout: false
  end
end
