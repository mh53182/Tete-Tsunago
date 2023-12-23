class Public::Children::PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @child = Child.find(params[:child_id])
    @posts = @child.posts.order(created_at: :desc).page(params[:page]).per(20)
    @post = Post.new
  end
  
end