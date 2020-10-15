class MessagesController < ApplicationController
  before_action :logged_in_user

  def show
    @user = User.find(params[:id])
    if current_user?(@user)
      @messages = (@user.senders + @user.receivers).uniq
    else
      message_ids = "SELECT id FROM messages
                     where sender_id = :current_user_id AND receiver_id = :user_id
                     OR sender_id = :user_id AND receiver_id = :current_user_id"
      message = Message.where("id IN (#{message_ids})",
                              current_user_id: current_user.id, user_id: @user.id).order("created_at ASC")
      @message = message.map{|m| m.sender_id == current_user.id ? m.attributes.merge({"myself": true, "time": m.created_at.strftime("%Y-%m-%d %H:%M")}) : m.attributes.merge({"myself": false, "time": m.created_at.strftime("%Y-%m-%d %H:%M")})}
    end
  end

  def update
    @user = User.find(params[:id])
    message = Message.new(sender: current_user, receiver: @user, content: params[:content])
    if message.save
      message_ids = "SELECT id FROM messages
                     where sender_id = :current_user_id AND receiver_id = :user_id
                     OR sender_id = :user_id AND receiver_id = :current_user_id"
      response = Message.where("id IN (#{message_ids})",
                                current_user_id: current_user.id, user_id: @user.id).order("created_at ASC")
      response = response.map{|m| m.sender_id == current_user.id ? m.attributes.merge({"myself": true, "time": m.created_at.strftime("%Y-%m-%d %H:%M")}) : m.attributes.merge({"myself": false, "time": m.created_at.strftime("%Y-%m-%d %H:%M")})}
      render json: response
    else
      render "show"
    end
  end

end
