class SessionsController < ApplicationController
  CHECKED_REMEMBER = Settings.sessions.checked_remember.to_s
  before_action :set_user, only: :create
  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == CHECKED_REMEMBER ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = t "static_pages.login.paragraph_invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
