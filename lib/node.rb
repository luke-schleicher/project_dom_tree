class TagNode

  attr_accessor :tag, :parent, :children

  def initialize(tag, parent = nil, children = [])
    @tag = tag
    @parent = parent
    @children = children
  end

end