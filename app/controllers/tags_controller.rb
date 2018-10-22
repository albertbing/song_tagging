class TagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :delete, :mytags]


  def mytags
    @user = current_user
    @tags=@user.songs
  end
end
