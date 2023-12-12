class Admin::PostsController < ApplicationController
  
  def show
    @post = Post.find(psrams[:id])
  end
  
end
