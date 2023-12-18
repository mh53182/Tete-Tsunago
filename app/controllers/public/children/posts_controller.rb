class Public::Children::PostsController < ApplicationController
  
  def index
    @child = Child.find(params[:child_id])
    @posts = @child.posts.order(created_at: :desc)
  end
  
end