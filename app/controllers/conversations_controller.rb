class ConversationsController < ApplicationController

  def index
    render json: {
        cats: ['what up', 'this','is','a','list']
    }
  end

  def fuck
    cat_card = CatCard.new(id: 2, title: 'meh')
    serialized_data = ActiveModelSerializers::Adapter::Json.new(
        CatCardSerializer.new(cat_card)
    ).serializable_hash
    ActionCable.server.broadcast 'conversations_channel', {data: ["done if i can see this"]}
    head :ok
  end
end
