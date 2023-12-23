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

    # フォローしている、アクティブかつ公開されているユーザーの取得
    @users = @user.followings.is_active.is_public

    # フォローしている、アクティブかつ公開されているユーザーの投稿の取得
    @posts = Post.from_followings_of(@user).from_active_users.from_public_users
                 .order(created_at: :desc).page(params[:page]).per(20)

    @post = Post.new
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers
  end

end