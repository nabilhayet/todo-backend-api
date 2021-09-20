![GitHub Repo stars](https://img.shields.io/github/stars/nabilhayet/Restaurant) ![GitHub forks](https://img.shields.io/github/forks/nabilhayet/Restaurant) ![GitHub followers](https://img.shields.io/github/followers/nabilhayet) ![Bitbucket open issues](https://img.shields.io/bitbucket/issues/nabilhayet/Restaurant)                                          
                                        <h1>:bomb: Todo-Backend :bomb: </h1>
                                                      
This project lets a user add a new todo. Before creating a todo a user needs to logged in and only registered users can sign in. After creating a todo, a user can see all the existing todos. Updating or deleting a todo option available to the user. At the end, all todos are cleared when the user logs out of the profile.

<a href="https://www.youtube.com/watch?v=54azoDzOMTc&t=1s">Demo</a>
<a href="https://github.com/nabilhayet/bookstore-frontend">Frontend</a>

Table of Contents
- [Features](#features)
- [Tech-Stack](#tech-stack)
- [Installing](#installing)
- [Challenges](#challenges)
- [Future-Implementation](#future-implementation)
- [Code-Snippet](#code-snippet)
                               
## Features
<ul>
 <li>Full CRUD capabilities for todos such as</li>
 <li>Add a new todo</li>
 <li>View all existing todos on this application</li>
 <li>Edit/Delete the todos</li>
 <li>Registering option for a user</li>
 <li>View profile after log in</li>
 <li>Clear todos after log out</li>
 <li>Search a todo by it's name</li>
</ul>

## Login
![book_details](https://user-images.githubusercontent.com/33500404/109563444-c7814200-7aad-11eb-860c-8fa1014a04a6.gif)

## Add Todo
![add_book](https://user-images.githubusercontent.com/33500404/109563397-b59f9f00-7aad-11eb-8f58-f4ced6935236.gif)

## View Todos
![view_authors](https://user-images.githubusercontent.com/33500404/109563556-ef70a580-7aad-11eb-882d-428043361340.gif)

## Edit/Delete Todo
![add_like](https://user-images.githubusercontent.com/33500404/109563422-bf290700-7aad-11eb-80a0-8ea67533311c.gif)

## Search Todo
![search_book](https://user-images.githubusercontent.com/33500404/109563467-cf40e680-7aad-11eb-8556-2d7e84ef88ad.gif)

## Logout
![view_books](https://user-images.githubusercontent.com/33500404/109563586-f992a400-7aad-11eb-83fb-463fe7a46e02.gif)

## Tech-Stack
<p>This web app makes use of the following:</p>

* ruby '2.6.1'
* rails, '~> 6.0.3', '>= 6.0.3.4'
* sqlite3, '~> 1.4'
* puma, '~> 4.1'
* sass-rails, '>= 6'
* webpacker, '~> 4.0'
* rack-cors
* pry
* active_model_serializers, '~> 0.10.0'


## Installing
<ul>
<li> Clone this repo to your local machine git clone <this-repo-url></li>
<li> run bundle install to install required dependencies</li>
<li> run rails db:create to create a database locally.</li>
<li> run rails db:migrate to create tables into the database.</li>
<li> run rails db:seed to create seed data.</li>
<li> run rails s to run the server.</li>
</ul>
        
## Challenges
<ul>
<li> The serializer wasn't working properly to filter out json data</li>
<li> Error message was not displaying on the DOM</li>
<li> It took me a while to figure out the user_params</li>
</ul>

## Future-Implementation
<ul>
<li> Add model and controller for todos</li>
  <li> Add session for login credentials for more security</li>
</ul> 

## Code-Snippet 

```
class User < ApplicationRecord
    has_secure_password 
    has_many :todos

    accepts_nested_attributes_for :todos
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
    validates :email, presence: true 
    validates :email, uniqueness: true
    validates :password, presence: true
    validates(:password, { :length => { :in => 4..16 } })
end

```

```
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email 
  has_many :todos 
end
```

```
class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    # should store secret in env variable
    JWT.encode(payload, 'my_s3cr3t')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, 'my_s3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end

 ```
 
 ```
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
```
