require 'pry'

class Parser

  DOCTYPE = /!doctype html/
  TAGS = /<[^>]+>/
  OPENING_TAG = /<\w+/
  TAG_TYPE = /\w+/
  TAG_ATTRIBUTE_VALUE_PAIR = /\s(.*?)\s*\=\s*\\*['|"](.*?)\\*['|"]/
  CLOSING_TAG = /<\/\w*\s*>/
  
  def remove_doctype(html_lines)
    html_lines.shift if html_lines[0].downcase.match(DOCTYPE)
    html_lines
  end

  def parse_line(line)
    tags = line.scan(TAGS)
    text = line.split(TAGS)
    text.shift if text[0] == ""
    content = tags.zip(text).flatten!
  end

  def opening_tag?(item)
    item.match(OPENING_TAG)
  end

  def text?(item)
    !item.match(TAGS)
  end

  def closing_tag?(item)
    item.match(CLOSING_TAG)
  end

  def get_tag_type(tag)
    tag.match(TAG_TYPE)[0]
  end

  def get_tag_attributes(tag)
    attributes = get_attributes_and_values(tag)
    build_attribute_hash(attributes)
  end

  def get_attributes_and_values(tag)
    tag.scan(TAG_ATTRIBUTE_VALUE_PAIR)
  end

  def build_attribute_hash(attributes)
    attribute_hash = Hash.new
    attributes.each do |pair|
      attribute_hash[pair[0]] = pair[1]
    end
    attribute_hash
  end

  # def type
  #   tag.type
  # end

  # def classes
  #   tag.attributes["class"]
  # end

  # def id
  #   tag.attributes["id"]
  # end

  # def has_child?
  # end

end

# TAG_ATTRIBUTE_VALUE_PAIR = /\s(.*?)\s*\=\s*['|"](.*?)['|"]/
