class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    user = User.find(params[:id])
    current_user.follow(user)
    redirect_to request.referer
  end
  
  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    redirect_to request.referer
  end
  
  def followings
    @user = User.find(params[:id])
    @users = @user.followings.includes(:posts)

    # 各ユーザーの投稿を集め、作成日時で降順に並び替える
    @posts = @users.map(&:posts).flatten.sort_by { |post| -post.created_at.to_i }.page(params[:page]).per(4)
    @post = Post.new
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end
  
end
