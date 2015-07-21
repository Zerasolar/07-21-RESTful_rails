class UsersController < ApplicationController
  
  def index
    if !params["log_out"].nil?
      session[:user_id] = nil
    end
  end
  
  def login
  end
  
  def new
    email = params["users"].permit("email")
    password = BCrypt::Password.create(params["users"].permit("password"))
    @new_user = User.create({"email" => email, "password" => password})
    
    if @new_user.valid?
    session[:user_id] = @new_user.id
    redirect "/users/#{@new_user.id}"
  else
    render "user/new"
  end
end
  
  def edit
  end
  
  def delete
  end
  
end
