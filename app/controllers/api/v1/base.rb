module API
  module V1
    class Base < Grape::API
      helpers API::V1::Helpers::Base

      mount API::V1::Auth
      mount API::V1::Users
    end
  end
end