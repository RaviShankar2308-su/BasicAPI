# frozen_string_literal: true

#  Used for the Login and Logout the user
# Create a new session of User whenever User get signed in
# And also destroy the session whenever User got signed out
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _options = {})
    if resource
      render json: {
        status: :ok, message: 'Signed In Successfully', data: current_user
      }
    else
      render json: {
        status: :unprocessable_entity, message: 'Invalid Credentials',
        errors: resource.errors.full_messages
      }
    end
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(
      request.headers['Authorization'].split(' ')&.last,
      Rails.application.credentials.fetch(:secret_key_base)
    ).first
    current_user = User.find(jwt_payload['sub'])

    current_user_response(current_user)
  end

  def current_user_response(current_user)
    if current_user
      render json: {
        status: :ok, message: 'Signed Out Successfully'
      }
    else
      render json: {
        status: :unauthorized,
        message: 'User has no active session'
      }
    end
  end
end
