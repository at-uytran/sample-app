class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t "password_resets.create.email_sent"
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t "password_resets.create.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, I18n.t("password_resets.update.cant_empty"))
      render :edit
    elsif @user.update_attributes(user_params)
      after_update
    else
      render :edit
    end
  end

  private

  def after_update
    @user.update_attribute(:reset_digest, nil)
    log_in @user
    flash[:success] = I18n.t "password_resets.update.success"
    redirect_to @user
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = I18n.t "password_resets.edit.expired"
  end

  def valid_user
    if @user && @user.activated? && @user.authenticated?(:reset, params[:id]) then true
    else
      flash[:danger] = I18n.t "password_resets.invalid_user"
      redirect_to root_path
    end
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = I18n.t "password_resets.update.user_not_found"
  end
end
