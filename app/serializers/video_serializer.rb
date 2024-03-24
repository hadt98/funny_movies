class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :link, :posted_at, :owner
  def posted_at
    object.created_at
  end
  def owner
    object.user.email
  end
  has_many :video_icons
end