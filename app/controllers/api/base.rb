module API
  class Base < Grape::API
    include Defaults
    mount API::V1::Base
  end
end