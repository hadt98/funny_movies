class ApplicationController < ActionController::API
  include JsonWebToken
  before_action :authenticate_request

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded, ok = jwt_decode(header)
    unless ok
      if decoded.nil?
        return { message: "missing token", status: :unauthorized }
      end
    end
    unless decoded.has_key?(:user_id)
      return { message: "invalid token", status: :unauthorized }
    end
    @current_user = User.find(decoded[:user_id])
    unless !!@current_user
      { message: "invalid user", status: :unauthorized }
    end
  end
end
