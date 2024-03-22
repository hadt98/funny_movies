module API
  module V1
    class Users < Grape::API
      before_validation do
        authenticate_request!
      end

      namespace :users do
      end
    end
  end
end