class Api::V1::UsersController < ApplicationController
  before_action :set_user, except: %i[create show_me]
  skip_before_action :authenticate_request, only: %i[create show]
  wrap_parameters :user, include: %i[ first_name last_name username gender
                                      email password password_confirmation
                                      birth_date phone_number ]

  def create
    @user = User.new(user_params)
    if @user.save
      render :show, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show; end

  def show_me
    @user = @current_user
    render :show, status: :ok
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render :show, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :gender,
                                 :email, :password, :password_confirmation,
                                 :birth_date, :phone_number)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
