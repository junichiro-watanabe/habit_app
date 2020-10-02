module ApplicationHelper
  def attached_image(model)
    model.image.attached? ? url_for(model.image) : "/assets/default-#{model.class.name}.png"
  end
end
