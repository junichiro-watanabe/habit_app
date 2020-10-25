# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = :ja
srand(0)

users_json = []
groups_json = []
messages_json = []
File.open("db/fixtures/users.json") do |j|
  users_json = JSON.load(j)
end
File.open("db/fixtures/groups.json") do |j|
  groups_json = JSON.load(j)
end
File.open("db/fixtures/messages.json") do |j|
  messages_json = JSON.load(j)
end

User.create!(name: "管理者ユーザ",
             email: "admin@example.com",
             introduction: "管理者ユーザです。よろしくお願いします。",
             password: "password",
             password_confirmation: "password",
             admin: true)

User.create!(name: "ゲストユーザ",
             email: "guest@example.com",
             introduction: "一時利用のためのゲストユーザです。よろしくお願いします。",
             password: "password",
             password_confirmation: "password")

users_json.length.times do |n|
  user = User.create!(name: Faker::Name.name,
                      email: "test#{n + 3}@example.com",
                      introduction: users_json[n]["introduction"],
                      password: "password",
                      password_confirmation: "password")
  user.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
end

2.times do |n|
  user = User.find(2)
  group = user.groups.build(name: "テストグループ #{n + 1}",
                            habit: "毎日habit appを起動しよう！",
                            overview: "ゲストユーザが作成したテストグループです。毎日habitappを起動して習慣づけを頑張りましょう！")
  group.save
  user.belong(group)
end

groups_json.length.times do |n|
  user = User.find(rand(3..User.count))
  group = user.groups.build(name: groups_json[n]["name"],
                            habit: groups_json[n]["habit"],
                            overview: groups_json[n]["overview"])
  group.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
  group.save
  user.belong(group)
end

2.upto User.count do |n|
  user = User.find(n)
  5.times do
    group = Group.find(rand(1..Group.count))
    user.belong(group) until user.belonging?(group)
  end
end

2.upto User.count do |n|
  user = User.find(n)
  10.times do
    other_user = User.find(rand(2..User.count))
    user.follow(other_user) until user.following?(other_user)
  end
end

messages_json.length.times do |n|
  my_user = User.find(2)
  your_user = User.find(rand(3..User.count))
  if (n % 2).zero?
    messages_json[n]["my_message"].length.times do |m|
      Message.create(sender_id: my_user.id, receiver_id: your_user.id, content: messages_json[n]["my_message"][m])
      Message.create(sender_id: your_user.id, receiver_id: my_user.id, content: messages_json[n]["your_message"][m])
    end
  else
    messages_json[n]["my_message"].length.times do |m|
      Message.create!(sender_id: your_user.id, receiver_id: my_user.id, content: messages_json[n]["your_message"][m])
      Message.create!(sender_id: my_user.id, receiver_id: your_user.id, content: messages_json[n]["my_message"][m])
    end
  end
end

((Date.today - 20)..(Date.today - 1)).each do |date|
  2.upto User.count do |n|
    user = User.find(n)
    user.belongs.each do |belong|
      next unless rand(2).zero?

      group = belong.group
      history = belong.achievement.histories.create(date: date)
      history.microposts.create(user: user, content: "#{history.date} 分の <a href=\"/groups/#{group.id}\">#{group.name}</a> の目標を達成しました。\n目標：#{group.habit}")
    end
  end
end

2.upto User.count do |n|
  user = User.find(n)
  Micropost.all.each do |micropost|
    user.like(micropost) if rand(100).zero?
  end
end
