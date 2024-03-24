class VideoIconSerializer < ActiveModel::Serializer
  attributes :code, :video_id, :user_id
end