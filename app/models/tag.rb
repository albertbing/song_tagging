class Tag < ApplicationRecord
  has_many :song_tags, dependent: :destroy
  has_many :songs, through: :song_tags

  belongs_to :creator,class_name: 'User', foreign_key: "created_by"

  validates :name, uniqueness: { allow_blank: false }
  validates_length_of :name, minimum: 3, allow_blank: false

end
