module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include JsonWebToken
    identified_by :current_user
    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      token = request.params['token']
      if token.present?
        # Validate and decode the token to get user information
        decoded_token, ok = jwt_decode(token)
        reject_unauthorized_connection unless ok

        if decoded_token.present? && (user_id = decoded_token[:user_id])
          return User.find_by(id: user_id)
        end
      end
      reject_unauthorized_connection
    end
  end
end
