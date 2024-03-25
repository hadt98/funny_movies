require 'rails_helper'

RSpec.describe AlertsChannel, type: :channel do
  it "successfully subscribes to the channel" do
    subscribe
    expect(subscription).to be_confirmed
  end

  it "broadcasts a message to the channel" do
    subscribe
    title = "video title"
    user_email = "test@example.com"
    expect {
      ActionCable.server.broadcast 'AlertsChannel', {
        title: title,
        owner: user_email
      }
    }.to have_broadcasted_to('AlertsChannel').with({
                                                      title: title,
                                                      owner: user_email
                                                    })
  end


end
