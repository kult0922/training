labels = {
  definition: '要件定義',
  basic_design: '基本設計',
  detail_design: '詳細設計',
  implementation: '実装',
  unit_test: '単体テスト',
  conbine_test: '結合テスト',
  comprehensive_test: '総合テスト'
}

labels.each do |code, name|
  Label.seed_once(:code,
    { code: code, name: name }
  )
end
