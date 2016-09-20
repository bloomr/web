class StaticController < ApplicationController
  def le_concept
  end

  def qui_sommes_nous
  end

  def templates
    render layout: 'home'
  end

  def new_home
    render layout: 'new_home'
  end

  def programme
    render layout: 'new_home'
  end

  def bred
    render layout: 'new_home'
  end
end
