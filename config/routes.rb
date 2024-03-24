Rails.application.routes.draw do
  mount API::Base, at: "/"
  mount ActionCable.server => '/cable'
end