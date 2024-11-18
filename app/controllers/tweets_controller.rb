class TweetsController < ApplicationController
      # GET /tweets
      def index_by_user
        # Retrieve the user based on the provided username
        user = User.find_by(username: params[:username])
      
        if user
          # Get all tweets by that user, ordered by creation date
          tweets = user.tweets.order(created_at: :desc)
      
          # Map the tweets to the desired response format
          tweet_data = tweets.map do |tweet|
            {
              id: tweet.id,
              username: tweet.user.username, # Only include username
              message: tweet.message
            }
          end
      
          # Render the tweets as JSON with the required structure
          render json: { tweets: tweet_data }, status: :ok
        else
          render json: { errors: ["User not found"] }, status: :not_found
        end
      end
      
      
      def index
        # Retrieve all tweets from the database, ordered by creation date
        tweets = Tweet.includes(:user).order(created_at: :desc)
      
        # Map the tweets to the desired response format
        tweet_data = tweets.map do |tweet|
          {
            id: tweet.id,
            username: tweet.user.username, # Only include username
            message: tweet.message
          }
        end
      
        # Render the tweets as JSON with the required structure
        render json: { tweets: tweet_data }, status: :ok
      end
      
      
    # POST /tweets
    def create
      # Retrieve the session token from the cookie
      session_token = cookies[:twitter_session_token]
  
      # Find the session based on the token
      session = Session.find_by(token: session_token)
  
      if session
        # Retrieve the current user from the session
        current_user = session.user
  
        # Create a new tweet associated with the current user
        tweet = current_user.tweets.new(tweet_params)
  
        if tweet.save
          render json: { message: "Tweet created successfully", tweet: tweet }, status: :created
        else
          render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: ["User not authenticated"] }, status: :unauthorized
      end
    end

    
    def destroy
      session_token = cookies[:twitter_session_token]
      session = Session.find_by(token: session_token)
    
      if session
        current_user = session.user
        tweet = current_user.tweets.find_by(id: params[:id])
    
        if tweet
          tweet.destroy
          render json: { success: true }, status: :ok
        else
          render json: { errors: ["Tweet not found"] }, status: :not_found
        end
      else
        render json: { success: false }, status: :unauthorized
      end
    end
    
    private
  
    # Strong parameters for tweet creation
    def tweet_params
      params.require(:tweet).permit(:message)
    end
  end
  