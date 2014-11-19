class HomeController < ApplicationController

  def index
    @portraits = User.where.not(:job_title => nil)
  end

end
