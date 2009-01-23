ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'

class RailsStory
  # def log_in_as_user user
  #   session = open_session
  #   session.post '/login/login', :user => { :id => user.id }
  #   session.session[ :user_id ].should == user.id
  #   session
  # end

end

