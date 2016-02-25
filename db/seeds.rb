# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Kind::KINDS_STRING.each do |kind|
  Kind.create(name: kind)
end

20.times do
  Snippet.create title: Faker::Company.bs ,
                 work:  Faker::Lorem.paragraph,
                 kind: Kind.all.sample,
                 is_private: false
end
