class FollowRequestsController < ApplicationController
  def index

    matching_follow_requests = FollowRequest.all

    if @current_user.id != matching_follow_requests.order({ :created_at => :desc }).last.recipient_id
        redirect_to("/", { :notice => "You're not authorized for that." })

      
    else


      @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

      render({ :template => "follow_requests/index.html.erb" })
    end
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.status = params.fetch("query_status")
    name = User.where(id: the_follow_request.recipient_id).first.username
    name = "/users/"+name
    if the_follow_request.valid?
        the_follow_request.save
        if the_follow_request.status == "accepted"
          redirect_to(name, { :notice => "Follow request created successfully." })
        else 
          redirect_to("/", { :notice => "Follow request created successfully." })

        end
        
      elsif the_follow_request.sender_id == the_follow_request.recipient_id 
        redirect_to(name)

      else
        redirect_to("/", { :notice => "Follow request created successfully." })
        
      end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/"+@current_user.username, { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/users/"+@current_user.username, { :alert => "Follow request failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.destroy

    redirect_to("/follow_requests", { :notice => "Follow request deleted successfully."} )
  end
end
