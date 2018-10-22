class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :songs,class_name: 'Song', foreign_key: "created_by"
  has_many :tags,class_name: 'Tag', foreign_key: "created_by"

  def create_song_with_tags title, tags
    if title.empty? || tags.empty?
      raise ArgumentError, 'Song title or tags can not be empty'
      return false
    else
      tags=tags.gsub(' ',',').split(',').map(&:strip).reject(&:empty?)
      song=Song.find_by(title: title)
      if song
        unless song.can_edited_by self
          raise "Somebody already created this song!"
        end
      else
        song=Song.create(title: title, created_by: self.id)
      end

      tags.each do |t|
        next if t.length<3
        tag=Tag.find_by(name: t)
        tag=Tag.create(name: t, created_by: self.id) unless tag

        song.tags<< tag unless song.tags.include? tag
      end

      if song.tags.length==0
        SongTag.where(song_id: song.id).destroy_all
        song.destroy
        raise 'The must be tags for songs'
      end
      return song
    end

  end
end
