class NotificationsController < ApplicationController
  def update
    user = User.find(params[:id])
    notifications = user.passive_notifications.where(checked: false)
    notifications.map do |n|
      n.toggle!(:checked)
    end
    response = user.notification
    render json: response
  end
end
