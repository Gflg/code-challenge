class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  # GET /users or /users.json
  # Used to show all users. I left this endpoint here to make tests easier to follow.
  def index
    @users = UserFinder.new.call
  end

  # GET /users/1 or /users/1.json
  # Used to show a specific user. I left this endpoint here to make tests easier to follow.
  def show
  end

  # GET /users/new
  # Used to load creation page
  def new
    @user = UserCreator.new.call
  end

  # POST /users or /users.json
  # Used to save data from a new user
  # It doesn't allow the creation of users with same email.
  # If current email already exists, it returns the corresponding user.
  # It also sends an email to the user's email address to validate the token and activate the user.

  # If the user is already active, it keeps the current user active and the current token is the same.
  # In this case, the token is changed when the user validate the new token received in its email.
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

  # It is used to activate a token that needs to be confirmed.
  # This function is responsible for processing the link sent to the user.
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
