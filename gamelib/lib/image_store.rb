include_class('javax.swing.ImageIcon')

class ImageStore
  def initialize
    @images = {}
  end
  
  def load_image(filename)
    return @images[filename] if @images.include? filename
    loaded_image = ImageIcon.new(filename).image
    @images[filename] = loaded_image
    loaded_image
  end
end