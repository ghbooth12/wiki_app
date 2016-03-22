test_users = (1..5).to_a.map do |n|
  User.new(
    email:    "test#{n}@example.com",
    password: "testtest"
  )
end

test_users.each do |user|
  user.skip_confirmation!
  user.save

  rand(3..5).times do
    wiki = user.wikis.create!(
      title:   Faker::Hipster.sentence,
      body:    Faker::Hipster.paragraph,
      private: [true, false].sample
    )

    wiki.update_attribute(:created_at, rand(10.minutes .. 7.days).ago)
  end
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
