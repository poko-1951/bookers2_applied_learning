class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]
  def show
    @user = User.find(params[:id])
    rooms = current_user.entries.pluck(:room_id)
    entries = Entry.find_by(user_id: @user.id, room_id: rooms)

    if entries.nil?
      @room = Room.new
      @room.save
      Entry.create(user_id: @user.id, room_id: @room.id)
      Entry.create(user_id: current_user.id, room_id: @room.id)
    else
      @room = entries.room
    end
  @chats = @room.chats
  @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.followed_by?(user) && user.followed_by?(current_user)
      redirect_to books_path
    end
  end
end
