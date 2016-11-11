require_relative 'loader'
require_relative 'HTML_tree'

html_lines = Loader.new.run
tree = HTMLTree.new(html_lines)
tree.build