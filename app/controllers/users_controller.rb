class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :load_user, except: %i(new index create)

  def index
    @users = User.activated.paginate page: params[:page]
  end

  def show
    redirect_to(root_path) && return unless @user.activated?
    @microposts = @user.microposts.created_desc.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = I18n.t "users.create.check_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = I18n.t "users.update.success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = I18n.t "users.destroy.success"
    redirect_to users_path
  end

  def following
    @title = I18n.t "users.following.title"
    @user = User.find_by id: params[:id]
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = I18n.t "users.followers.title"
    @user = User.find_by id: params[:id]
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = I18n.t "users.show.not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    load_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
