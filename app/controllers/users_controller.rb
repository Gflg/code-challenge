class UsersController < ApplicationController
  before_action :set_user_handler
  before_action :set_user, only: %i[ show ]

  # GET /users or /users.json
  def index
    @users = @user_handler.find_all_users
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    user_handler = UserHandler.new
    @user = user_handler.create_user
  end

  # POST /users or /users.json
  def create
    @user_handler = UserHandler.new(user_params)
    @user = @user_handler.get_or_create_user

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
    @user_handler = UserHandler.new(id: params[:id])
    @user = @user_handler.activate_user_token
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
    def set_user_handler
      @user_handler = UserHandler.new(params)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user_handler = UserHandler.new(id: params[:id])
      @user = @user_handler.find_user
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :token, :is_active)
    end
end
