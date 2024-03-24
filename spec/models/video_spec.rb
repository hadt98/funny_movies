require 'rails_helper'

RSpec.describe Video, type: :model do
  it "is valid with valid attributes" do
    link = 'https://www.youtube.com/watch?v=thK_ujnkm1s&ab_channel=Deezer'
    title = 'title'
    video_id = 'thK_ujnkm1s'
    description = 'description'
    user = create(:user)
    stub_youtube_data
    video = Video.create!(link: link, video_id: video_id, title: title, description: description, user_id: user[:id])
    expect(video).to be_valid
  end
  it "is invalid with missing link " do
    link = ''
    title = 'title'
    video_id = 'thK_ujnkm1s'
    description = 'description'
    user = create(:user)

    expect {
      Video.create!(link: link, video_id: video_id, title: title, description: description, user_id: user[:id])
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "is invalid with link is not a youtube link" do
    link = 'https://guides.rubyonrails.org/action_cable_overview.html'
    title = 'title'
    video_id = 'thK_ujnkm1s'
    description = 'description'
    user = create(:user)

    expect {
      Video.create!(link: link, video_id: video_id, title: title, description: description, user_id: user[:id])
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "is invalid duplicate video for one user" do
    link = 'https://www.youtube.com/watch?v=thK_ujnkm1s&ab_channel=Deezer'
    title = 'title'
    video_id = 'thK_ujnkm1s'
    description = 'description'
    user = create(:user)
    stub_youtube_data
    video_1 = Video.create!(link: link, video_id: video_id, title: title, description: description, user_id: user[:id])
    expect(video_1).to be_valid
    expect {
      Video.create!(link: link, video_id: video_id, title: title, description: description, user_id: user[:id])
    }.to raise_error(ActiveRecord::RecordInvalid)
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