module API::V1
  class Videos < Grape::API
    helpers do
      def paging(domain, page = 1, per_page = 10, order_by = 'created_at', order_dir = 'desc')
        domain = domain.order("#{order_by} #{order_dir}").offset((page - 1) * per_page).limit(per_page)
        {
          total_count: domain.count,
          data: domain
        }

      end
    end

    namespace :public do
      desc "get list videos public by all users"
      params do
        optional :per_page, type: Integer, default: 10
        optional :page, type: Integer, default: 1
      end
      get "/videos" do
        page = params[:page]
        per_page = params[:per_page]
        videos = Video
        paging(videos, page, per_page)
      end
    end

    namespace :videos do
      before_validation do
        authenticate_request!
      end

      desc "get list videos by current user"
      params do
        optional :per_page, type: Integer, default: 10
        optional :page, type: Integer, default: 1
      end
      get "/mine" do
        declared_params = declared(params)
        page = declared_params[:page]
        per_page = declared_params[:per_page]

        videos = Video.where(user_id: @current_user[:id])
        paging(videos, page, per_page)
      end

      desc "get link youtube info"
      params do
        requires :link, type: String, regexp: /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
      end
      get "/youtube_info" do
        declared_params = declared(params, include_missing: false)
        youtube_client = YoutubeClient.new

        data, ok = youtube_client.get_video_info_by_link(declared_params[:link])
        unless ok
          error!("invalid video", 400)
        end
        data
      end

      desc "create a video by link"
      params do
        requires :link, type: String, regexp: /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
      end
      post "" do

        declared_params = declared(params, include_missing: false)
        video = Video.create!(link: declared_params[:link], user_id: @current_user[:id])
        raise_error_if_invalid!(video)
        video
      end

      desc "add reaction to video"
      params do
        requires :id, type: Integer
        requires :icon, type: String
      end
      post ":id/add_reaction" do
        declared_params = declared(params, include_missing: false)
        video = Video.where(id: declared_params[:id], user_id: @current_user[:id]).first
        if video.nil?
          error!("video not found", 400)
        end
        p video
        rs, ok = video.add_reaction(@current_user, declared_params[:icon])
        unless ok
          error!(rs, 400)
        end
        return rs
      end

    end

  end
end