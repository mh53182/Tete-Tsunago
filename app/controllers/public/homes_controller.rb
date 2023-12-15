class Public::HomesController < ApplicationController

  def top
    redirect_to admin_root_path if admin_signed_in?
  end

  def about
  end

end
