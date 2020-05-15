class MessagesChannel < ApplicationCable::Channel
  def subscribed
    puts "gets here #{params.inspect} params"
    stream_from "conversations_channel"
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
