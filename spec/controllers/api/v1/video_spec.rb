require 'rails_helper'

RSpec.describe API::V1::Auth, type: :request do

  describe "POST /" do
    context "create a video success" do
      it "return success" do
        stub_youtube_data
        link = 'https://www.youtube.com/watch?v=99uabJJUFX4'
        post_with_token "/api/v1/videos", body: { link: link }
        p json_body
        expect(response.status).to eq(201)

        expect(json_body["link"]).to eq link
      end
    end

    context "unauthenticated user" do
      it "return error" do
        stub_youtube_data
        link = 'https://www.youtube.com/watch?v=99uabJJUFX4'
        post_without_token "/api/v1/videos", body: { link: link }
        expect(response.status).to eq(401)
      end
    end

    context "invalid youtube link" do
      it "return error invalid link" do
        stub_youtube_data
        link = 'https://guides.rubyonrails.org/action_cable_overview.html'
        post_with_token "/api/v1/videos", body: { link: link }
        expect(response.status).to eq(400)
        expect(json_body["error"]).to eq 'link is invalid'
      end
    end

    context "post duplicated video" do
      it "return error" do
        user = create(:user)
        stub_youtube_data
        link = 'https://www.youtube.com/watch?v=99uabJJUFX4'
        post_with_token "/api/v1/videos", body: { link: link }, user: user
        expect(response.status).to eq(201)
        expect(json_body["link"]).to eq link

        post_with_token "/api/v1/videos", body: { link: link }, user: user
        expect(response.status).to eq(422)
        expect(json_body["error"]).to include "posted by you"
      end
    end
  end

  describe "GET /public" do
    context "get all videos public by all user" do
      it "return success" do
        user1 = create(:user)
        stub_youtube_data
        video = create(:video, user: user1)
        stub_youtube_data
        video2 = create(:video, user: user1, created_at: 1.days.ago)
        stub_youtube_data
        video3 = create(:video, user: user1, created_at: 2.days.ago)
        user2 = create(:user)
        stub_youtube_data
        video4 = create(:video, user: user2, created_at: 3.days.ago)
        get_without_token("/api/v1/public/videos")
        expect(response.status).to eq(200)
        expect(json_body["total_count"]).to eq 4
        expect(json_body["data"][0]).to include(
                                          "id" => video[:id],
                                          "user_id" => user1[:id],
                                          "title" => "title",
                                          "description" => "description"
                                        )
        expect(json_body["data"].map { |v| v["id"] }).to eq([video.id, video2.id, video3.id, video4.id])

      end
    end
  end

  describe "GET /mine" do
    context "get all videos public by current user" do
      it "return success" do
        user1 = create(:user)
        stub_youtube_data
        video1 = create(:video, user: user1)
        stub_youtube_data
        video2 = create(:video, user: user1, created_at: 10.days.ago)
        stub_youtube_data
        video3 = create(:video, user: user1, created_at: 5.days.ago)

        user2 = create(:user)
        create(:video, user: user2)

        get_with_token("/api/v1/videos/mine", user: user1)
        expect(response.status).to eq(200)
        expect(json_body["total_count"]).to eq 3
        array = [{ name: "Alice", age: 30 }, { name: "Bob", age: 25 }]
        expect(array).to include(name: "Alice", age: 30)
        expect(json_body["data"][0]).to include(
                                          "id" => video1[:id],
                                          "user_id" => user1[:id],
                                          "title" => "title",
                                          "description" => "description"
                                        )
        expect(json_body["data"].map { |video| video["id"] }).to eq([video1.id, video3.id, video2.id])

      end
    end
    context "unauthenticated user" do
      it "return error" do
        user1 = create(:user)
        stub_youtube_data
        link = 'https://www.youtube.com/watch?v=99uabJJUFX4'
        post_with_token "/api/v1/videos", body: { link: link }, user: user1
        expect(response.status).to eq(201)
        expect(json_body["link"]).to eq link

        get_without_token("/api/v1/videos/mine")
        expect(response.status).to eq(401)

      end
    end

  end

  describe "POST /add_reaction" do
    context "add reaction to video" do
      it "return success" do
        user = create(:user)
        stub_youtube_data
        video = create(:video, user: user)
        post_with_token "/api/v1/videos/#{video["id"]}/add_reaction", body: { icon: 'like' }, user: user
        expect(response.status).to eq(201)
        expect(json_body["video_id"]).to eq video.id
        expect(json_body["user_id"]).to eq user.id
        expect(json_body["code"]).to eq 'like'

      end
    end
    context "unauthenticated user" do
      it "return error" do
        user = create(:user)
        stub_youtube_data
        video = create(:video, user: user)
        post_without_token "/api/v1/videos/#{video["id"]}/add_reaction", body: { icon: 'like' }
        expect(response.status).to eq(401)

      end
    end

    context "unsupported reaction" do
      it "return error" do
        user = create(:user)
        stub_youtube_data
        video = create(:video, user: user)
        post_with_token "/api/v1/videos/#{video["id"]}/add_reaction", body: { icon: 'love' }, user: user
        expect(response.status).to eq(400)
      end
    end

  end
  describe "GET /videos/youtube_info" do
    context "get video from a link" do
      it "return success" do
        user = create(:user)
        link = 'https://www.youtube.com/watch?v=99uabJJUFX4'
        stub_youtube_data
        get_with_token("/api/v1/videos/youtube_info", user: user, params: {link: link})
        expect(response.status).to eq(200)
        expect(json_body).to include(
                                          "title" => "title",
                                          "description" => "description"
                                        )

      end
    end
  end


  def stub_youtube_data(video_id: SecureRandom.uuid)
    data = [{
              video_id: video_id,
              title: "title",
              description: "description",
              published_at: "",
              channel_title: "channel"
            }, true]

    allow_any_instance_of(YoutubeClient).to receive(:get_video_info_by_link).and_return(data)
  end

end