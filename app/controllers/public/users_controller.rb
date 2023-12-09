class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @post = Post.new
    @posts = @user.posts
  end

  def edit
  end

  def update
  end
  
  def favorites
  end

  def confirm
  end

  def withdraw
  end
end
