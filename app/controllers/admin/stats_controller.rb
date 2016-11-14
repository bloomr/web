module Admin
  class StatsController < ApplicationController
    before_action :authenticate_admin_user!

    def index
    end
  end
end
