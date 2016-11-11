require_relative 'parser'
require_relative 'tag_node'
require_relative 'text_node'

Tag = Struct.new(:type, :attributes)

class HTMLTree

  attr_accessor :html_lines, :parser, :root

  def initialize(html_lines)
    @html_lines = html_lines
    @parser = Parser.new
    @root = nil
  end

  def build
    html_lines = parser.remove_doctype(self.html_lines)
    build_html_tree
  end


  def build_html_tree

    stack = []

    @html_lines.each do | line |

      # remove newlines
      line = line.strip.chomp

      p line

      # pass the line to the parser and return array of tags and text
      element_array = @parser.parse_line(line)

      # iterate over array to create nodes
      build_nodes(element_array, stack)

    end
  end

  def build_nodes(element_array, stack)

    return if element_array.nil?

    if element_array.is_a?(String)
      create_text(element_array) 
      return
    end

    element_array.each do |item|

      next if item == nil

    # if hit opening tag, create tag object and node
      if parser.opening_tag?(item)
        tag = create_tag(item)
        create_node(tag, stack)
      end 

      # if the parser finds raw text
      # set the text string as a child of its parent node
      create_text(item, stack) if parser.text?(item)

      # if the parser finds a closing tag
      # pop off last item in stack
      close_tag(item, stack) if parser.closing_tag?(item)

    end
  end      

  # create the tag if the parser finds an opening tag
  def create_tag(tag)    
    tag_type = parser.get_tag_type(tag)
    tag_attributes = parser.get_tag_attributes(tag)
    tag = Tag.new(tag_type, tag_attributes)
  end

  def create_node(tag, stack)

    # create note with tag and set last node on stack as parent of node
    node = TagNode.new(tag, stack[-1])

    # make node root if no root 
    self.root ||= node

    # set the node as a child of last node on stack
    stack[-1].children << node unless stack.empty?

    # push the node onto the stack
    stack << node

  end

  def create_text(text, stack)
    node = TextNode.new(text, stack[-1])
    stack[-1].children << node unless stack.empty?
  end

  def close_tag(tag, stack)
    stack.pop
  end

  # tag = @parser.parse_tag(line)
  # node = Node.new(tag)
  # @root ||= node
  # @stack << node

end