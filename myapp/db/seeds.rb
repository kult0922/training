# coding: utf-8
User.create!(
  [
    {
      name: '楽天花子',
      email: 'hanako.rakuten@example.com',
      password: 'hanako123',
      role: 0,
    },
    {
      name: '楽天太郎',
      email: 'taro.rakuten@example.com',
      password: 'taro',
      role: 0,
    },
    {
      name: '管理者太郎',
      email: 'taro.admin@example.com',
      password: 'abc123',
      role: 1,
    }
  ]
)
