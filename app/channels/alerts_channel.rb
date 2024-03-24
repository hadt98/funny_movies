class AlertsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'AlertsChannel'
  end

  def unsubscribed

  end
end
