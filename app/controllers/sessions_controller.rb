class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = UserFinder.new(confirmed_token: params[:user][:token]).call
    if @user
        login @user
        redirect_to invoices_path, notice: "Signed in."
    else
      flash.now[:alert] = "Incorrect token."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end
end
