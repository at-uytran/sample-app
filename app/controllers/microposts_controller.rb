class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = I18n.t "microposts.create.success"
      redirect_to root_path
    else
      flash[:danger] = I18n.t "microposts.create.fail"
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = I18n.t "microposts.create.success"
      redirect_to request.referer || root_path
    else
      flash[:danger] = I18n.t "microposts.create.fail"
      render "static_pages/home"
    end
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path if @micropost.nil?
  end

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end
end
