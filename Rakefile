require 'rubygems'
require 'rake'
 
begin
  require 'echoe'

  Echoe.new('render-caching', '0.1.0') do |p|
    p.summary        = "Cache render calls in Rails controllers."
    p.description    = "Cache render calls in Rails controllers."
    p.url            = "http://github.com/ryanb/render-caching"
    p.author         = 'Ryan Bates'
    p.email          = "ryan (at) railscasts (dot) com"
    p.ignore_pattern = ["script/*", "*.gemspec"]
  end

rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
