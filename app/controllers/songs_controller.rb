class SongsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :delete, :mysongs]

  def index
      
      @q = Song.ransack(params[:q])
      @songs = @q.result.paginate(:page => params[:page], :per_page => 30)
    unless params[:q]
      @songs=Song.paginate(:page => params[:page], :per_page => 30)
    end
      if  request.xhr?
        render json: @songs.to_json(:include => :tags)
        return
      end
  end

  def search

  end
  def mysongs
    @user = current_user
    @songs=@user.songs.paginate(:page => params[:page], :per_page => 30)
    @song=Song.new
  end

  def new
    @song=Song.new
    render :layout => false
  end

  def create
     begin
      song=current_user.create_song_with_tags params[:song][:title], params[:tags]
      render json: song.to_json(:include => :tags)
     rescue  =>e
       render :json => {"error" => e.to_s}.to_json
     end
  end

  def edit
    if self.can_edited_by current_user
    @song=Song.find(params[:id]).include(:tags)
    else
      raise 'You are not authorized to edit this song'
    end
  end

  def update
    
    @song=Song.find(params[:id])
    if @song.can_edited_by current_user
      begin
        @song.update params[:song][:title], params[:tags]
        render json: @song.to_json(:include => :tags)
      rescue  =>e
        render :json => {"error" => e.to_s}.to_json
      end

    else
      render :json => {"error" => "You are not authorized to update this song"}.to_json
    end
  end

  def destroy
    @song=Song.find(params[:id])
    if @song && (@song.can_edited_by current_user)
      begin
        @song.destroy!
        render :json => {"success" => "deleted"}.to_json
        rescue  =>e
        render :json => {"error" => e.to_s}.to_json
      end
    else
      render :json => {"error" => 'You are not authorized to update this song'}.to_json
    end
  end

  def remove_tag
    
    @song=Song.find(params[:id])
    if @song.can_edited_by current_user
      begin
        tag=Tag.find(params[:tag_id])
        @song.tags.delete(tag)
        render :json => {"success" => "deleted"}.to_json
      rescue  =>e
        render :json => {"error" => e.to_s}.to_json
      end
    else
      render :json => {"error" => 'You are not authorized to update this song'}.to_json
    end
  end

  def remove_tag_with_songs

    @song=Song.find(params[:id])
    if @song.can_edited_by current_user
      begin
        tag=Tag.find(params[:tag_id])
        @song.tags.delete(tag)
        render :json => {"success" => "deleted"}.to_json
      rescue  =>e
        render :json => {"error" => e.to_s}.to_json
      end
    else
      render :json => {"error" => 'You are not authorized to update this song'}.to_json
    end
  end

  def download
    #byebug
    @songs=Song.where(id: JSON.parse(params[:ids]))
    respond_to do |format|
      format.csv  { render :template => "songs/download.csv", :layout => false}
    end
  end
end
