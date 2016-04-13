class TribesController < ApplicationController
  def index
    @tribes = Tribe.all
  end

  def show
    @tribe = Tribe.find_by normalized_name: params[:id]
  end
end
