module API
  module V1
    class Users < Grape::API
      before_validation do
        authenticate_request!
      end

      namespace :users do
        desc "current info"
        get "/me" do
          @current_user
        end
      end
    end
  end
end