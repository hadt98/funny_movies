require 'google/apis/youtube_v3'

class YoutubeClient
  YT_LINK_FORMAT = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/

  def youtube_service
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = "AIzaSyAbOzhelLQv-HKWWKdJIN1VVzKumDeT99A"
    return youtube
  end

  def get_video_info_by_link(video_link)
    # validate youtube link
    match = video_link.match(YT_LINK_FORMAT)
    return "link is invalid" unless match
    video_id = video_link[/\?v=([^&]+)/, 1]

    video = self.youtube_service.list_videos('snippet', id: video_id).items.first

    return 'could not fetch video from youtube', false unless video

    [{
       video_id: video_id,
       title: video.snippet.title,
       description: video.snippet.description,
       published_at: video.snippet.published_at,
       channel_title: video.snippet.channel_title,
       link: video_link
     }, true]
  end

end