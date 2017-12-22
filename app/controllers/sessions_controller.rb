class SessionsController < ApplicationController
  CHECKED_REMEMBER = Settings.sessions.checked_remember.to_s
  before_action :set_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated? then checked_activate
      else
        flash[:warning] = t ".check_mail_message"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".paragraph_invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def checked_activate
    log_in @user
    params[:session][:remember_me] == CHECKED_REMEMBER ? remember(@user) : forget(@user)
    redirect_back_or @user
  end

  def set_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
