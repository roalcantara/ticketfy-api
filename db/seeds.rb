%w(admin).each do |seed|
  require File.join(File.dirname(__FILE__), "seeds/#{seed}")
end
