module Invoiced::RequestHelper
  include JsonWebToken

  def json_body
    @json_body ||= begin
                     response.body.sub(/^\)\]\}'\,\n/, '')
                     JSON.parse(body)
                   end
  end

  def post_with_token(path, body: {}, headers: {}, user: nil)
    user ||= create(:user)
    sign_in(user, headers)
    post path, params: body, headers: headers, as: :json
  end

  def sign_in(user, headers)
    jwt = jwt_encode(user_id: user.id)
    headers['Authorization'] ||= "Bearer #{jwt[:token]}"
  end
end

RSpec.configure do |config|
  config.include Invoiced::RequestHelper

end
