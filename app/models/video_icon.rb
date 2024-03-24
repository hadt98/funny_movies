class VideoIcon < ApplicationRecord
  belongs_to :video

  validates :video_id, presence: true
  validates :code, presence: true
  validates :count, presence: true
  scope :by_code, -> (code) { where(code: code) }

end
