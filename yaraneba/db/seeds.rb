User.create!(
  email: 'yu.oikawa@rakuten.com',
  password: '12345',
  deleted_at: Time.zone.now.since(10.day).strftime('%Y-%m-%d')
)
