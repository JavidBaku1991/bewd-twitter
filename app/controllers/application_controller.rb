# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  private

  def current_user
    user = Session.find_by(token: session[:token])&.user
    Rails.logger.debug "Current user: #{user.inspect}"
    user
  end
end
