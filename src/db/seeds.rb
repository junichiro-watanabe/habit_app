# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = :ja
srand(0)

User.create!(name: "ゲストユーザ",
             email: "guest@example.com",
             password: "password",
             password_confirmation: "password")

99.times do |n|
  user = User.create!(name: Faker::Name.name,
                     email: "test#{n}@example.com",
                     introduction: Faker::Lorem.sentence,
                     password: "password",
                     password_confirmation: "password")
  if rand(2) == 0 || rand(2) == 1
    user.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
  end
  user.save
end

2.times do |n|
  user = User.find(1)
  group = user.groups.build(name: Faker::Team.name,
                            habit: Faker::Job.title,
                            overview: Faker::Lorem.sentence)
  if rand(2) == 0 || rand(2) == 1
    group.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
  end
  group.save
  user.belong(group)
end

48.times do |n|
  user = User.find(rand(1..100))
  group = user.groups.build(name: Faker::Team.name,
                            habit: Faker::Job.title,
                            overview: Faker::Lorem.sentence)
  if rand(2) == 0 || rand(2) == 1
    group.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
  end
  group.save
  user.belong(group)
end

100.times do |n|
  user = User.find(n + 1)
  1.upto 10 do |m|
    group = Group.find(rand(1..50))
    user.belong(group) until user.belonging?(group)
  end
end
