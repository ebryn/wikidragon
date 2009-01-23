class ApplicationController < ActionController::Base
  protect_from_forgery unless RAILS_ENV=='test'

  def identify_user
    logged_in = User.find_by_id( session[ :user_id ] )
    unless logged_in
      session[ :destination_after_login ] = params
      redirect_to( :controller => "login", :action => "login" )
    end
  end
end
