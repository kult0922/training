labels = {
  function_addition: '機能追加',
  infrastructure: 'インフラ',
  system_issue: 'システム課題',
  refactoring: 'リファクタリング',
  design: 'デザイン',
  bugfix: 'バグ修正',
  others: 'その他'
}

labels.each do |code, name|
  Label.seed_once(:code,
    { code: code, name: name }
  )
end
