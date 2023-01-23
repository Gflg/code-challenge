class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  # GET /users or /users.json
  def index
    @users = UserFinder.new.call
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = UserCreator.new.call
  end

  # POST /users or /users.json
  def create
    @user = UserCreator.new(user_params.merge(create_unique: true)).call

    respond_to do |format|
      if @user.save
        UserMailer.with(user: @user).activate_user_token.deliver_later
        format.html { redirect_to root_url, notice: "Mail was sent to confirm access." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate_token
    @user = UserTokenActivator.new(id: params[:id]).call
    respond_to do |format|
      if @user.save
        login @user
        format.html { redirect_to invoices_url, notice: "User was successfully activated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = UserFinder.new(id: params[:id]).call
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :token, :is_active)
    end
end
