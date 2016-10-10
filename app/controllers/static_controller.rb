class StaticController < ApplicationController
  def templates
    render layout: 'home'
  end

  %w( home program bred press concept
      bloomifesto qui_sommes_nous ).each do |name|
    define_method(name) { render layout: 'new_home' }
  end
end
