FactoryBot.define do
  factory :label_function_addition, class: Label do
    code { 'function_addition' }
    name { '機能追加' }
  end

  factory :label_infrastructure, class: Label do
    code { 'infrastructure' }
    name { 'インフラ' }
  end

  factory :label_system_issue, class: Label do
    code { 'system_issue' }
    name { 'システム課題' }
  end

  factory :label_refactoring, class: Label do
    code { 'refactoring' }
    name { 'リファクタリング' }
  end

  factory :label_design, class: Label do
    code { 'design' }
    name { 'デザイン' }
  end

  factory :label_bugfix, class: Label do
    code { 'bugfix' }
    name { 'バグ修正' }
  end

  factory :label_others, class: Label do
    code { 'others' }
    name { 'その他' }
  end
end
