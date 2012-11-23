# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# (1..100).each do |i|
#   User.create!(:name => "user_#{i}", :email => "#{i}@pp.com", :password => "111111", :password_confirmation => "111111")
# end

User.all.each do |u|
  rand(10).times do |i|
    u.posts.create!(:title => "user_#{u.id}_post_#{i+i}", :content => "postpostpostpostpostpostpostpostpostpostpostpostpostpostpost", :reward => (100-i*10))
  end
end
