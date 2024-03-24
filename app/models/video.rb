class Video < ApplicationRecord

  validates :link, presence: true
  validates :title, presence: true
  validates :user_id, presence: true
  validates :video_id, presence: true

  before_validation :get_video_info, on: :create

  after_validation :validate_duplicate_video, on: :create

  has_many :video_icons
  belongs_to :user

  after_create :alert_created_video

  scope :by_owner, -> (owner) { where(user_id: owner) }
  scope :by_id, ->(id) { where(id: id) }

  def validate_duplicate_video
    existed = Video.where(user_id: self.user_id, video_id: self.video_id).exists?
    if existed
      errors.add(:base, "video is posted by you: #{self.link}")
    end
  end

  def get_video_info
    data, ok = youtube_client.get_video_info_by_link(self.link)

    unless ok
      errors.add(:base, data)
      return
    end
    self.video_id = data[:video_id]
    self.source = "Youtube"
    self.title = data[:title]
    self.description = data[:description]
  end

  def youtube_client
    YoutubeClient.new
  end

  def add_reaction(user, icon)
    # check if type exist in icon table
    supported_icons = %w[like dislike]
    unless supported_icons.include?(icon)
      return "reaction not valid", false
    end
    reaction = VideoIcon.where(video_id: self.id.to_i, code: icon, user_id: user[:id]).first
    if reaction.blank?
      reaction = VideoIcon.create!(video_id: self.id.to_i, code: icon, user_id: user[:id])
    else
      reaction.destroy!
    end
    return reaction, true
  end

  def alert_created_video
    ActionCable.server.broadcast 'AlertsChannel', {
      title: title,
      owner: user.email
    }
  end
end
