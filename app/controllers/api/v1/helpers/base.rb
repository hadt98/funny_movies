module API
  module V1
    module Helpers::Base

      include JsonWebToken
      def authenticate_request!
        token = request.headers["Authorization"] || request.headers["authorization"]
        jwt = token.split(" ").last if token
        decoded, ok = jwt_decode(jwt)
        unless ok
          if decoded.nil?
            error!("token missing", 401)
          end
        end
        unless decoded.has_key?(:user_id)
          return error!("invalid token", 401)
        end
        @current_user = User.find(decoded[:user_id])
        unless !!@current_user
          error!("invalid user", 401)
        end
        @current_user
      end

      def raise_error_if_invalid!(model)
        error!({ error: model.errors.full_messages.join(", ") }, 422) unless model.errors.empty? && model.valid?
      end
    end
  end
end
