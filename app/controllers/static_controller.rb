class StaticController < ApplicationController
  %w( home program bred press concept
      bloomifesto qui_sommes_nous bouygues ).each do |name|
    define_method(name) {}
  end
end
