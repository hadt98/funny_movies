class Video < ApplicationRecord

  validates :link, presence: true
  validates :title, presence: true
  validates :user_id, presence: true
  validates :video_id, presence: true

  before_validation :get_video_info, on: :create

  after_validation :duplicate_video, on: :create

  has_many :video_icons
  belongs_to :user

  after_create :new_video_alert

  scope :by_owner, -> (owner) { where(user_id: owner) }
  scope :by_id, ->(id) { where(id: id) }

  def duplicate_video
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

  def add_reaction(icon_code, total, type)
    # check if type exist in icon table
    icon = Icon.where(code: icon_code).first
    unless icon
      return "reaction not valid", false
    end
    reaction = VideoIcon.where(video_id: self.id.to_i, code: icon_code).first
    unless reaction
      reaction = VideoIcon.create!(video_id: self.id.to_i, code: icon_code, count: 0)
    end
    count = reaction[:count].to_i
    if type == "add"
      count += total
    else
      count = 0 ? count <= total : count - total
    end
    reaction.update(count: count)
    return reaction, true
  end

  def new_video_alert
    ActionCable.server.broadcast 'AlertsChannel', {
      title: title,
      owner: user.email
    }
  end
end
