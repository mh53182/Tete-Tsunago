class Public::ChildrenController < ApplicationController
  before_action :authenticate_user!

  def new
    @child = Child.new
  end

  def create
    @child = Child.new(child_params)
    @child.user_id = current_user.id
    if @child.save
      flash[:notice] = "お子様情報が登録されました"
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "お子様情報が登録できませんでした"
      render :new
    end
  end

  def edit
    @child = Child.find(params[:id])
    
    # editページへのアクセス元（users/showまたはchildren/posts/index）のセッションへの保存
    session[:previous_url] = request.referer
  end

  def update
    @child = Child.find(params[:id])
    if @child.update(child_params)
      flash[:notice] = "お子様情報が更新されました"
      
      # セッションに保存したeditページへのアクセス元へリダイレクト
      redirect_to session[:previous_url]
    else
      flash.now[:alert] = "お子様情報が更新できませんでした"
      render :edit
    end
  end

  private

  def child_params
    params.require(:child).permit(:nickname, :birthday)
  end

end
