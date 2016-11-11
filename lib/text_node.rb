class TextNode

  attr_accessor :text, :parent

  def initialize(text, parent = nil)
    @text = text
    @parent = parent
  end

end
