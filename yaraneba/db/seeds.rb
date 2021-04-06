User.create!(
  email: 'yu.oikawa@rakuten.com',
  password: '12345',
  role_id: 1,
  deleted_at: Time.zone.now.since(10.day).strftime('%Y-%m-%d')
)

Role.create!(
  id: 1,
  role_name: 'admin'
)

Role.create!(
  id: 2,
  role_name: 'member'
)
