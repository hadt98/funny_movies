class User < ApplicationRecord
  require "securerandom"
  include JsonWebToken
  has_secure_password
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  has_many :videos
  has_many :video_icons

  def gen_jwt(email, password)

  end
end
