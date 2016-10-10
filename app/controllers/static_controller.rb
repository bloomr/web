class StaticController < ApplicationController
  def qui_sommes_nous
  end

  def templates
    render layout: 'home'
  end

  %w( home program bred press concept bloomifesto ).each do |name|
    define_method(name) { render layout: 'new_home' }
  end
end
