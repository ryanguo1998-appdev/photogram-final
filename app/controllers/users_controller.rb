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

    render({ :template => "users/show.html.erb"})
  end

end