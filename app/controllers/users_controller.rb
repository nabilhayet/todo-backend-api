class UsersController < ApplicationController
 # before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    @user = User.find_by(id: params[:id])
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(email: params[:email], password: params[:password])
    if @user.save
      session[:user_id] = @user.id 
      render json: @user, status: :created, location: @user
    else
      resp = {
        error: "Invalid credentials",
        details: @user.errors.full_message 
      }
      render json: resp, status: :unauthorized 
    end
  end

  def login 
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.authenticate(params[:user][:password])
      render json: @user
    else 
      resp = {
        error: "Invalid credentials",
        details: @user.errors.full_message 
      }
      render json: resp, status: :unauthorized 
      
    end 
  end 

  def destroy
    session.clear
  end 

end
