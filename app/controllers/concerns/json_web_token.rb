require 'jwt'

module JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base

  def jwt_encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    if token.nil?
      return nil, false
    end
    decoded = JWT.decode(token, SECRET_KEY)[0]
    return HashWithIndifferentAccess.new(decoded), true
  end
end