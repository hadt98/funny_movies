class V1::VideosController < ApplicationController
  def create


  end

  private
  def create_video_param
    params.require(:link)
  end
end
