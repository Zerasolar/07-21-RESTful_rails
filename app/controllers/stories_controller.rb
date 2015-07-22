class StoriesController < ApplicationController
  
  # List a user's stories
  def index
    @user = User.find(session[:user_id])
    @user_stories = Story.where(user_id: @user.id)
    if @user.id == session[:user_id]
      @current_user = true
    else
      @current_user = false
    end
    render "stories/index"
  end

  # Create a new story for a user
  def new
    @user = User.find(session[:user_id])
    @new_story = Story.new
    render "stories/new"
  end

  # Validate and save the new story for a user
  def save_new
    @user = User.find(session[:user_id])
    title = params["stories"]["title"]
    summary = params["stories"]["summary"]
    @new_story = Story.create({"title" => title, "summary" => summary, "user_id" => @user.id})

    if @new_story.valid?
          @user = User.find(session[:user_id])
      render "/stories/#{@new_story.id}"
    else
      render "stories/new"
    end

  end
  
  # Delete a user's story
  def delete
    @user = User.find(session[:user_id])
    @user_stories = Story.where(user_id: @user.id)
    story_id = Story.find(params["stories"]["id"])
    story_id.delete
    redirect_to "/stories"
  end

  # Edit a user's story
  def edit_story
      @user = User.find(session[:user_id])
      @story = Story.find(params["stories"]["id"])
      render "stories/edit"
  end

  # Validate and save an existing user's story
  def edited_story
    @user = User.find(session[:user_id])
    @story = Story.find(params["stories"]["id"])
    @story.title = params["stories"]["title"]
    @story.summary = params["stories"]["summary"]
    @story.save

    if !@story.valid?
      @story
      render "stories/edit"
    else
      redirect_to "/stories"
    end
  end

  # # Show a user's story's information
  # get "/users/:user_id/stories/:id" do
  #   @story = Story.find(params["id"])
  #   erb :"stories/show"
  # end

end
