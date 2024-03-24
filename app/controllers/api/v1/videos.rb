module API::V1
  class Videos < Grape::API
    helpers do
      def authen_request
        authenticate_request!
      end
    end

    namespace :videos do
      desc "get list videos public by all users"
      params do
        optional :per_page, type: Integer, default: 10
        optional :page, type: Integer, default: 1
      end
      get "/public" do
        page = params[:page]
        per_page = params[:per_page]
        order_by = 'created_at'
        order_dir = 'desc'

        # Calculate total count
        total_count = Video.count

        # Fetch paginated records with ordering
        videos = Video.order("#{order_by} #{order_dir}").offset((page - 1) * per_page).limit(per_page)

        {
          data: videos,
          total_count: total_count
        }

      end

      desc "get list videos by current user"
      params do
        optional :per_page, type: Integer, default: 10
        optional :page, type: Integer, default: 1
      end
      get "/mine" do
        authen_request
        declared_params = declared(params)
        page = declared_params[:page]
        per_page = declared_params[:per_page]
        order_by = 'created_at'
        order_dir = 'desc'

        # Calculate total count
        total_count = Video.where(user_id: @current_user[:id]).count

        # Fetch paginated records with ordering
        videos = Video.where(user_id: @current_user[:id]).order("#{order_by} #{order_dir}").offset((page - 1) * per_page).limit(per_page)
        p videos
        {
          data: videos,
          total_count: total_count
        }
      end

      desc "create a video by link"
      params do
        requires :link, type: String, regexp: /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
      end
      post "" do
        authen_request
        declared_params = declared(params, include_missing: false)
        video = Video.create!(link: declared_params[:link], user_id: @current_user[:id])
        raise_error_if_invalid!(video)
        video
      end

      desc "add reaction to video"
      params do
        requires :id, type: Integer
        requires :icon, type: String
        requires :total, type: Integer
      end
      post ":id/add" do
        authen_request
        declared_params = declared(params, include_missing: false)
        video = Video.where(id: declared_params[:id], user_id: @current_user[:id]).first
        if video.nil?
          error!("video not found", 400)
        end
        p video
        rs, ok = video.add_reaction(declared_params[:icon], declared_params[:total], "add")
        unless ok
          error!(rs, 400)
        end
        return rs
      end

      desc "remove reaction to video"
      params do
        requires :id, type: Integer
        requires :icon, type: String
        requires :total, type: Integer
      end
      post ":id/remove" do
        authen_request
        declared_params = declared(params, include_missing: false)
        video = Video.by_id(declared_params["id"]).by_owner(@current_user["id"])
        if video.nil?
          error!("video not found", 400)
        end
        rs, ok = video.add_reaction(declared_params[:icon], declared_params[:total], "substract")
        unless ok
          error!(rs, 400)
        end
        return rs
      end
    end

  end
end