module ApplicationHelper
  def attached_image(model)
    model.image.attached? ? rails_blob_path(model.image) : "/assets/default-#{model.class.name}.png"
  end
end
