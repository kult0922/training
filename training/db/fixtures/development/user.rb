User.create!(
  name: Faker::Movies::StarWars.character,
  email: Faker::Internet.email,
  password: 'password',
  is_admin: true
)
