if User.all.empty?
  admin = User.create!(name: 'admin')
  general = User.create!(name: 'general-user', role: :general_user)
  AuthInfo.create!(email: 'abc@example.com', password: 'password', user: admin)
  AuthInfo.create!(email: '123@example.com', password: 'password', user: general)
end

if Label.all.empty?
  ('A'..'E').each do |s|
    Label.create!(name: "Label_#{s}", user: admin)
  end

  (1..5).each do |n|
    Label.create!(name: "Label_#{n}", user: general)
  end
end

50.times do |n|
  Task.create!(
    name: "task#{'%02d' % n}",
    description: "This is task#{'%02d' % n}",
    have_a_due: [true, false].sample,
    due_at: Random.rand(Time.zone.tomorrow..Time.zone.tomorrow.next_year),
    status: Task.statuses.values.sample,
    user: User.all.sample
  )
end
