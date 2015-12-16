class BloomiesController < ApplicationController
  def create
    puts params
    render text: params.inspect
  end
end
