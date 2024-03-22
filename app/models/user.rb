class User < ApplicationRecord
  require "securerandom"
  include JsonWebToken
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  def gen_jwt(email, password)

  end
end
