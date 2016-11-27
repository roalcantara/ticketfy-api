%w(admin agent).each do |seed|
  require File.join(File.dirname(__FILE__), "seeds/#{seed}")
end
