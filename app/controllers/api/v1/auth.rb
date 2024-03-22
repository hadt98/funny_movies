module API
  module V1
    class Auth < Grape::API
      include JsonWebToken

      namespace :auth do
        desc "register a user"
        params do
          requires :email, type: String
          requires :password, type: String
        end
        post :register do
          declared_params = declared(params, include_missing: false)
          user = User.create(declared_params)
          raise_error_if_invalid!(user)
          user
        end

        desc "login"
        params do
          requires :email, type: String
          requires :password, type: String
        end
        post :login do

          user = User.find_by_email(params[:email])
          error!("wrong password or email", 401) unless user&.authenticate(params[:password])
          jwt_encode(user_id: user.id)
        end

      end
    end
  end
end