class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create, :login]
 # protect_from_forgery
    
   
 # before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end


  def show 
    if logged_in?
      @user = current_user
      render json: {user: @user, status: :ok}
    else 
      render json: {error: "No current user"}
    end 
  end 

  # POST /users
  def create
    @user = User.new(email: params[:email], password: params[:password])
    if @user.save
     # session[:user_id] = @user.id 
     payload = {user_id: @user.id}
            token = encode_token(payload)
            render json: {user: @user, jwt: token}
    else
      render json: {status: "error", errors: @user.errors, code:3000, message: "This id does not exist" }
    end
  end

  def login 
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      payload = {user_id: @user.id}
      token = encode_token(payload)
      render json: {user: @user, jwt: token}
    else 
      render json: {status: "error", code:3000, message: "This id does not exist" }
      
    end 
  end 

  def destroy
     if session.clear
      render json: { message: "You have successfully logged out" }, status: :ok 
     else 
      render json: {error: "something went wrong!"}, status: 500 
     end 
  end 

  

 

end
