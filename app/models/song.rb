class Song < ApplicationRecord
  has_many :song_tags, dependent: :destroy
  has_many :tags, through: :song_tags

  belongs_to :creator,class_name: 'User', foreign_key: "created_by"
  accepts_nested_attributes_for :song_tags, allow_destroy: true

  validates :created_by, presence: true
  validates :title, uniqueness: { allow_blank: false }
  validates_length_of :title, minimum: 3
  
  def update title, new_tags
    if title.empty? || new_tags.empty?
      raise ArgumentError, 'Song title or tags can not be empty'
      return false
    else
      new_tags=new_tags.gsub(' ',',').split(',').map(&:strip).reject(&:empty?)
      SongTag.where(song_id: self.id).destroy_all
      new_tags.each do |t|
        next if t.length<3
        tag=Tag.find_by(name: t)
        tag=Tag.create(name: t, created_by: self.created_by) unless tag
        self.tags<< tag unless self.tags.include? tag
      end
      if self.tags.length==0
        SongTag.where(song_id: self.id).destroy_all
        self.destroy
        raise 'The must be tags for songs'
      end
      return self
    end
  end

  def can_edited_by user
    self.created_by==user.id
  end
  
  private



end
