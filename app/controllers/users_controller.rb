class UsersController < ApplicationController
  def index_by_user
    user = User.find_by(username: params[:username])
  
    if user
      tweets = user.tweets
      render json: tweets.map { |tweet| { id: tweet.id, username: user.username, message: tweet.message } }, status: :ok
    else
      render json: { errors: ["User not found"] }, status: :not_found
    end
  end
    # POST /users
    def create
      user = User.new(user_params)
      if user.save
        render json: {
          user: {
            username: user.username,
            email: user.email
          }
        }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
  
    private
  
    # Strong parameters to allow only safe attributes
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
  end
  