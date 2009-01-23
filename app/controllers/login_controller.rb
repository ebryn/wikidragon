class LoginController < ApplicationController

  layout "nodes"

  def login
    unless request.post?
      @users = User.find( :all )  # find users so we can display a button for each existing user
    end
    
    if request.post?
      if params[ :user ][ :id ]   # they clicked on existing user button:
        @user = User.find_by_id( params[ :user ][ :id ] )
      else                        # they entered a new user name:
        @user = User.new( params[ :user ] )
        if not @user.save
          if @user.errors.on( :name ) == ActiveRecord::Errors.default_error_messages[ :taken ] 
            flash[ :error ] = 'This username is taken.  Please enter a unique username, or select from the existing users below'
          else
            flash[ :error ] = 'Failure saving new user'
          end
        end
      end
      session[ :user_id ] = @user.id
      goto_expected_destination
    end
  end

  def logout
    session[ :user_id ] = nil
    flash[ :notice ] = 'You has been logged out.'
    redirect_to( :controller => 'nodes' )
  end

  private

  def goto_expected_destination
    if session[ :destination_after_login ]
      redirect_to session[ :destination_after_login ]   
      session[ :destination_after_login ] = nil   
    else
      redirect_to( root_path )
    end
  end
  
end
