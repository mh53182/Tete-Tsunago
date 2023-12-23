class Admin::PostsController < ApplicationController

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "投稿が削除されました"
    redirect_back fallback_location: admin_posts_path
  end

end
