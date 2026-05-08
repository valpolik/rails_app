class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:create, :login]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:show, :update, :destroy]

  def index
    render json: { users: User.all.as_json(only: user_readable_attributes) }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user.as_json(only: user_readable_attributes), token: @user.generate_token_for(:authentication) }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { user: @user.as_json(only: user_readable_attributes) }
  end

  def update
    if @user.update(user_params)
      render json: { user: @user.as_json(only: user_readable_attributes) }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def login
    @user = User.find_by(email: params.dig(:user, :email))

    if @user&.authenticate(params.dig(:user, :password))
      render json: { user: @user.as_json(only: user_readable_attributes), token: @user.generate_token_for(:authentication) }
    else
      render json: { errors: ['Invalid credentials'] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_readable_attributes
    [:id, :email, :created_at]
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    @current_user = User.find_by_token_for(:authentication, token) if token.present?
    render json: { errors: ['Unauthorized'] }, status: :unauthorized unless @current_user
  end

  def authorize_user!
    render json: { errors: ['Forbidden'] }, status: :forbidden unless @current_user == @user
  end
end
