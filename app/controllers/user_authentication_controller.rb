class UserAuthenticationController < ApplicationController
  # Uncomment this if you want to force users to sign in before any other actions
  # skip_before_action(:force_user_sign_in, { :only => [:sign_up_form, :create, :sign_in_form, :create_cookie] })

  def discover
    @the_user_name = params.fetch("path_id")
    @the_user = User.where(username: @the_user_name).at(0)
    @following = FollowRequest.where(sender_id:  @the_user.id, status: "accepted")
    render({:template => "user_authentication/discover.html.erb"})
  end

  def feed
    @the_user_name = params.fetch("path_id")
    @the_user = User.where(username: @the_user_name).at(0)
    @following = FollowRequest.where(sender_id:  @the_user.id, status: "accepted")
    render({:template => "user_authentication/feed.html.erb"})
  end


  def liked
    @the_user_name = params.fetch("path_id")
    @the_user = User.where(username: @the_user_name).at(0)
    @liked_photos = Like.where(fan_id:  @the_user_id)
    render({:template => "user_authentication/liked.html.erb"})
  end


  def index

    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "user_authentication/index.html.erb"})
  end

  def show

    if session[:user_id] == nil
      redirect_to("/user_sign_in", { :alert => "You have to sign in first." })
    elsif FollowRequest.where(recipient_id: params.fetch("path_id").to_i, sender_id: @current_user.id, status: "accepted").length == 1 ||  User.where({ :username =>  params.fetch("path_id") }).at(0).private == FALSE || @current_user == User.where({ :username =>  params.fetch("path_id") }).at(0)
      
      
      the_id = params.fetch("path_id")

      matching_user = User.where({ :username => the_id })

      @the_user = matching_user.at(0)

      render({ :template => "user_authentication/show.html.erb" })
    else
      redirect_to("/users", { :alert => "You're not authorized for that." })

      
    end
  end

  def sign_in_form
    render({ :template => "user_authentication/sign_in.html.erb" })
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def sign_up_form
    render({ :template => "user_authentication/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.comments_count = 0
    @user.likes_count = 0
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.private = params.fetch("query_private", false)
    @user.username = params.fetch("query_username")
    @user.photos_count = 0

    save_status = @user.save

    if save_status == true
      session[:user_id] = @user.id
   
      redirect_to("/", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => @user.errors.full_messages.to_sentence })
    end
  end
    
  def edit_profile_form
    render({ :template => "user_authentication/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user.email = params.fetch("query_email")
    @user.comments_count = params.fetch("query_comments_count")
    @user.likes_count = params.fetch("query_likes_count")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.private = params.fetch("query_private", false)
    @user.username = params.fetch("query_username")
    @user.photos_count = params.fetch("query_photos_count")
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "user_authentication/edit_profile_with_errors.html.erb" , :alert => @user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end
 
end
