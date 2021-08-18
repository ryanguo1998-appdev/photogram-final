class UsersController < ApplicationController

  def index
    @all_users = User.all.order({ :username => :asc})
    
    render({ :template => "users/index.html.erb"})
  end

  def show
    the_username = params.fetch("path_id")
    matching_user = User.where({ :username => the_username })
    @the_user = matching_user.at(0)

    the_user_id = User.where( :username => the_username ).at(0).id
    accepted_follows = FollowRequest.where({ :status => "accepted"})
    matching_followers = accepted_follows.where({ :recipient_id => the_user_id})
    @num_followers = matching_followers.size

    matching_followings = accepted_follows.where({ :sender_id => the_user_id})
    @num_following = matching_followings.size

    logged_in_user = User.where({ :id => session[:user_id]}).at(0)
    if session[:user_id] != nil
      if @the_user.private == true
        if matching_followers.where({ :sender_id => logged_in_user.id}).at(0) != nil
          render({ :template => "users/show.html.erb"})
        else
          redirect_to("/", {:alert => "You're not authorized for that."})
        end
      end
    else
      redirect_to("/user_sign_in", {:alert => "You have to sign in first."})
    end
  end

end