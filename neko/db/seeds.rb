3.times do |n|
  User.create!(
    name: "user#{n}"
  )
end

30.times do |n|
  Task.create!(
    name: "task#{'%02d' % n}",
    description: "This is task#{'%02d' % n}",
    have_a_due: [true, false].sample,
    due_at: Random.rand(Time.zone.tomorrow..Time.zone.tomorrow.next_year),
    status: Task.statuses.values.sample,
    user: User.all.sample
  )
end
