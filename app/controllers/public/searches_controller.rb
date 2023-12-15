class Public::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @key_word = params[:key_word]

    if @model == "user"
      @records = User.search_for(@key_word)
    else
      @records = Post.search_for(@key_word)
    end
  end

end