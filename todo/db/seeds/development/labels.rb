# frozen_string_literal: true

Label.create!(
  color: :blue,
  text: '進行OK'
)

Label.create!(
  color: :gray,
  text: '遅れ'
)

Label.create!(
  color: :yellow,
  text: '注意'
)

Label.create!(
  color: :red,
  text: '要対応'
)

Label.create!(
  color: :green,
  text: '完了'
)

Label.create!(
  color: :sky,
  text: 'レビュー依頼'
)

Label.create!(
  color: :black,
  text: '不明'
)
