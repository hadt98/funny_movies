class VideoIcon < ApplicationRecord
  belongs_to :video
  belongs_to :user

  validates :video_id, presence: true
  validates :code, presence: true
  validates :user_id , presence: true

  scope :by_code, -> (code) { where(code: code) }

end
