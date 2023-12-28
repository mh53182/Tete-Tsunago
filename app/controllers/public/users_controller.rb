class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit, :withdraw]
  before_action :redirect_unless_current_user, only: [:edit, :update, :confirm, :withdraw]

  def show
    @user = User.find(params[:id])

    # 非公開アカウントおよび退会アカウントのぷろへの直アクセスを制限
    unless @user.is_active && (@user.is_public || @user == current_user)
      redirect_to user_path(current_user), alert: "アクセスできません"
    end

    @post = Post.new
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(20)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールが更新されました"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :edit
    end
  end

  def favorites
    @user = User.find(params[:id])

    # PostとFavoriteのデータを結合して取得
    # そのうちfavoriteのuser_idが@userであるものを取得
    # さらに有効かつ公開ユーザーの投稿に絞り込み新着順に並べ替え
    @posts = Post.joins(:favorites).where(favorites: { user_id: @user.id })
                 .from_active_users.from_public_users
                 .order(created_at: :desc).page(params[:page]).per(20)

    @post = Post.new
  end

  def confirm
    @user = User.find(params[:id])
  end

  def withdraw
    user = current_user
    user.update(is_active: false)
    reset_session
    redirect_to root_path, notice: "退会が完了しました。　ご利用ありがとうございました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :is_public, :profile_image)
  end

  # ゲストユーザーの確認
  def ensure_guest_user
    user = User.find(params[:id])
    if user.guest_user?
      redirect_to user_path(current_user), alert: "ゲストユーザーはプロフィールの編集・退会はできません"
    end
  end

  # URL指定による他人の情報編集制限
  def redirect_unless_current_user
    user = User.find(params[:id])
    if user.id != current_user.id
      redirect_to user_path(current_user), alert: "他のユーザーの編集・退会はできません"
    end
  end

end