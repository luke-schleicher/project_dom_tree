class Loader

  def run
    puts "Which HTML document would you like to parse?"
    file = gets.chomp
    html_line_array = File.readlines(file)
  end

end