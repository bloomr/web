class TribesController < ApplicationController
  def index
    @tribes = Tribe.all
  end
end
