module FunnyMovies::RequestHelper
  include JsonWebToken

  def json_body
    # @json_body ||= begin
    response.body.sub(/^\)\]\}'\,\n/, '')
    JSON.parse(body)
    # end
  end

  def post_with_token(path, body: {}, headers: {}, user: nil)
    user ||= create(:user)
    sign_in(user, headers)
    post path, params: body, headers: headers, as: :json
  end

  def post_without_token(path, body: {}, headers: {})
    post path, params: body, headers: headers, as: :json
  end

  def get_with_token(path, params: {}, headers: {}, user: nil)
    user ||= create(:user)
    sign_in(user, headers)
    get path, params: params, headers: headers
  end

  def get_without_token(path, params: {}, header: {})
    get path, params: params, headers: headers
  end

  def sign_in(user, headers)
    jwt = jwt_encode(user_id: user.id)
    headers['Authorization'] ||= "Bearer #{jwt[:token]}"
  end
end

RSpec.configure do |config|
  config.include FunnyMovies::RequestHelper

end
