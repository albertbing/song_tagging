# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# create users
user1=User.create(email:'test1@test.com', password: "123456")
user2=User.create(email:'test2@test.com', password: "123456")

csv_text = File.read(Rails.root.join('lib', 'seeds', '1000_cues_with_tags.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')

user=user1
csv.each do |row|
  user.create_song_with_tags row['song'], row['tags']
  user= user==user1 ? user2 : user1
end
