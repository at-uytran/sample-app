class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.created_desc.build
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def about; end

  def contact; end

  def help; end
end
