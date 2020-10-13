module ApplicationHelper
  def attached_image(model)
    model.image.attached? ? url_for(model.image) : "/assets/default-#{model.class.name}.png"
  end

  def create_authenticity_token
    session[:csrf_id] = form_authenticity_token
  end
end
