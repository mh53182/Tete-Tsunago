class Public::ChildrenController < ApplicationController
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
  end

  def update
    @child = Child.find(params[:id])
    if @child.update(child_params)
      flash[:notece] = "お子様情報が更新されました"
      redirect_to user_path(current_user)
    else
      flash[:now] = "お子様情報が更新できませんでした"
      render :edit
    end
  end
  
  private
  
  def child_params
    params.require(:child).permit(:nickname, :birthday)
  end

end
