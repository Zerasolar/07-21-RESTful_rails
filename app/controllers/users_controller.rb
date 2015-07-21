class UsersController < ApplicationController
  
  def index
    if !params["log_out"].nil?
      session[:user_id] = nil
    end
  end
  
  def login
    render "users/login"
  end
  
  def authenticate_login
    entered_email = params["users"]["email"]
    @user_email = User.find_by(email: entered_email)

    if !@user_email.nil?
      @valid = true
      given_pw = params["users"]["password"]
      actual_pw = BCrypt::Password.new(@user_email.password)
      if actual_pw == given_pw
        session[:user_id] = @user_email.id
        render "users/index"
      else
        @valid = false
        render "users/login"
      end
    else
      @valid = false
      render "users/login"
    end
  end
  
  def new_form
    @new_user = User.new
    render "users/new"
  end
  
  def new
    email = params["users"]["email"]
    password = BCrypt::Password.create(params["users"]["password"])
    @new_user = User.create({"email" => email, "password" => password})

    if @new_user.valid?
      session[:user_id] = @new_user.id
      render "/users/#{@new_user.id}"
    else
      render "users/new"
    end
  end
  
  def delete
    render "users/delete"
  end
  
  def confirm_delete
    if params["confirm_delete"] == "yes"
      user = User.find(session[:user_id])
      user.delete
      session[:user_id] = nil
      render "/users/index"
    else
      render "/users/index"
    end
  end
  
  def edit_profile
    @user = User.find(session[:user_id])
    render "users/edit"
  end

  def edited_profile
    @user = User.find(session[:user_id])
    @user.email = params["users"]["email"]
    encrypted_password = BCrypt::Password.create(params["users"]["password"])
    @user.password = encrypted_password
    @user.save

    if !@user.valid?
      @user
      render "users/edit"
    else
      render "users/index"
    end
  end


  def user_info
    @user = User.find(params["id"])
    render "users/show"
  end
  
end