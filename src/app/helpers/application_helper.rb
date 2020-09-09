module ApplicationHelper
  def display_attached_image(model)
    model.image.attached? ? image_tag(model.image) : image_tag("/assets/default-#{model.class.name}.png")
  end
end
