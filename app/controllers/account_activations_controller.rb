class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = I18n.t "account_activation.edit.activated"
      redirect_to user
    else
      flash[:danger] = I18n.t "account_activation.edit.invalid_link"
      redirect_to root_path
    end
  end
end
