require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:general) { create(:user) }
  let!(:admin) { create(:user, role: 0) }

  before do
    visit login_path
    fill_in 'session_mail_address', with: admin.mail_address
    fill_in 'session_password', with: admin.password
    click_on 'ログイン'
  end

  describe '#index' do
    context '管理者ユーザの場合' do
      let!(:user1) { create(:user, name: 'user1', created_at: DateTime.now) }
      let!(:task) { create(:task, user_id: user1.id) }
      let!(:user2) { create(:user, name: 'user2', created_at: DateTime.now + 100) }
      let!(:user3) { create(:user, name: 'user3', created_at: DateTime.now + 1000) }

      it '登録済みユーザ一覧が作成日時の降順で表示される' do
        visit admin_users_path
        expect(page).to have_content user1.name
        expect(page).to have_content user2.name
        expect(page).to have_content user3.name
        expect(page).to have_content user1.mail_address
        expect(page).to have_content user2.mail_address
        expect(page).to have_content user3.mail_address
        expect(page).to have_content user1.tasks.size
        expect(page).to have_content user2.tasks.size
        expect(page).to have_content user3.tasks.size
        expect(page.body.index(user1.name)).to be < page.body.index(user2.name)
        expect(page.body.index(user2.name)).to be < page.body.index(user3.name)
      end
    end

    context '一般ユーザの場合' do
      it 'ユーザ一覧画面に遷移できない' do
        click_on 'ログアウト'
        fill_in 'session_mail_address', with: general.mail_address
        fill_in 'session_password', with: general.password
        click_on 'ログイン'
        visit admin_users_path
        expect(current_path).to eq root_path
      end
    end
  end

  describe '#show' do
    let!(:taskA) { create(:task, title: 'taskA', user_id: general.id) }

    context '管理者ユーザの場合' do
      it '登録済みユーザ情報の詳細情報が表示される' do
        visit admin_user_path(general.id)
        expect(page).to have_content general.id
        expect(page).to have_content general.name
        expect(page).to have_content general.mail_address
        expect(page).to have_content taskA.title
        expect(page).to have_content '中'
        expect(page).to have_content '未着手'
        expect(page).to have_content taskA.due
      end
    end

    context '一般ユーザの場合' do
      it 'ユーザ詳細画面に遷移できない' do
        click_on 'ログアウト'
        fill_in 'session_mail_address', with: general.mail_address
        fill_in 'session_password', with: general.password
        click_on 'ログイン'
        visit admin_user_path(general.id)
        expect(current_path).to eq root_path
      end
    end
  end

  describe '#create' do
    context '管理者ユーザの場合' do
      before do
        visit new_admin_user_path
        fill_in 'user_name', with: 'user'
        fill_in 'user_mail_address', with: 'test100@example.com'
        select '一般ユーザ', from: 'user_role'
        fill_in 'user_password', with: 'pAssw0rd'
        fill_in 'user_password_confirmation', with: 'pAssw0rd'
      end

      context '正常な値が入力された場合' do
        it 'ユーザ一覧画面に遷移し、新規ユーザが一覧に表示されている' do
          click_on '登録'
          expect(page).to have_content 'user'
          expect(page).to have_content 'test100@example.com'
          expect(page).to have_content '一般ユーザ'
        end
      end

      context '異常な値が入力された場合' do
        context 'ユーザ名が空欄の場合' do
          it ' エラーメッセージが表示される' do
            fill_in 'user_name', with: ''
            click_on '登録'
            expect(page).to have_content 'ユーザ名を入力してください'
          end
        end

        context 'メールアドレスが空欄の場合' do
          it ' エラーメッセージが表示される' do
            fill_in 'user_mail_address', with: ''
            click_on '登録'
            expect(page).to have_content 'メールアドレスを入力してください'
          end
        end

        context 'メールアドレスに使用できない文字列が含まれる場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_mail_address', with: '!?@example.com'
            click_on '登録'
            expect(page).to have_content 'メールアドレスは不正な値です'
          end
        end

        context '既に登録済みのメールアドレスの場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_mail_address', with: general.mail_address
            click_on '登録'
            expect(page).to have_content 'メールアドレスはすでに存在します'
          end
        end

        context 'パスワードが空欄の場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_password', with: ''
            click_on '登録'
            expect(page).to have_content 'パスワードを入力してください'
          end
        end

        context 'パスワードとパスワード確認の内容が異なる場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_password_confirmation', with: ''
            click_on '登録'
            expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          end
        end

        context 'パスワードポリシーに反する場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_password', with: 'passw0rd'
            fill_in 'user_password_confirmation', with: 'passw0rd'
            click_on '登録'
            expect(page).to have_content 'パスワードは半角6~100文字英大文字・小文字・数字それぞれ１文字以上含む必要があります'
          end
        end
      end
    end

    context '一般ユーザの場合' do
      it 'ユーザ登録画面に遷移できない' do
        click_on 'ログアウト'
        fill_in 'session_mail_address', with: general.mail_address
        fill_in 'session_password', with: general.password
        click_on 'ログイン'
        visit new_admin_user_path
        expect(current_path).to eq root_path
      end
    end
  end

  describe '#update' do
    context '管理者ユーザの場合' do
      before { visit edit_admin_user_path(general.id) }

      context '正常な値が入力された場合' do
        it 'ユーザ一覧画面に遷移し、新規ユーザが一覧に表示されている' do
          fill_in 'user_name', with: 'updated_user'
          click_on '更新'
          expect(page).to have_content 'updated_user'
        end
      end

      context '異常な値が入力された場合' do
        context 'ユーザ名が空欄の場合' do
          it ' エラーメッセージが表示される' do
            fill_in 'user_name', with: ''
            click_on '更新'
            expect(page).to have_content 'ユーザ名を入力してください'
          end
        end

        context 'メールアドレスが空欄の場合' do
          it ' エラーメッセージが表示される' do
            fill_in 'user_mail_address', with: ''
            click_on '更新'
            expect(page).to have_content 'メールアドレスを入力してください'
          end
        end

        context 'メールアドレスに使用できない文字列が含まれる場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_mail_address', with: '!?@example.com'
            click_on '更新'
            expect(page).to have_content 'メールアドレスは不正な値です'
          end
        end

        context '既に登録済みのメールアドレスの場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_mail_address', with: admin.mail_address
            click_on '更新'
            expect(page).to have_content 'メールアドレスはすでに存在します'
          end
        end

        context 'パスワードとパスワード確認の内容が異なる場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_password', with: 'pAssw0rd'
            fill_in 'user_password_confirmation', with: 'Passw0rd'
            click_on '更新'
            expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          end
        end

        context 'パスワードポリシーに反する場合' do
          it 'エラーメッセージが表示される' do
            fill_in 'user_password', with: 'passw0rd'
            fill_in 'user_password_confirmation', with: 'passw0rd'
            click_on '更新'
            expect(page).to have_content 'パスワードは半角6~100文字英大文字・小文字・数字それぞれ１文字以上含む必要があります'
          end
        end
      end
    end

    context '一般ユーザの場合' do
      it 'ユーザ登録画面に遷移できない' do
        click_on 'ログアウト'
        fill_in 'session_mail_address', with: general.mail_address
        fill_in 'session_password', with: general.password
        click_on 'ログイン'
        visit edit_admin_user_path(general.id)
        expect(current_path).to eq root_path
      end
    end
  end

  describe '#destroy' do
    before { visit admin_users_path }

    it 'ダイアログが表示される' do
      page.dismiss_confirm do
        click_link '削除', match: :first
        expect(page.driver.browser.switch_to.alert.text).to eq '削除しますか？'
      end
    end

    context '一般ユーザを削除する場合' do
      it '一覧画面にユーザ削除完了のメッセージが表示される' do
        page.accept_confirm do
          click_link '削除', match: :first
        end
        expect(page).to have_content 'ユーザを削除しました'
        expect(User.general.size).to eq 0
      end
    end

    context '管理者を削除する場合' do
      context 'DBに登録されている管理者が複数件ある場合' do
        let!(:admin) { create(:user, role: 0) }

        it '一覧画面にユーザ削除完了のメッセージが表示される' do
          page.accept_confirm do
            click_link '削除', match: :first
          end
          expect(page).to have_content 'ユーザを削除しました'
          expect(User.admin.size).to eq 1
        end
      end

      context 'DBに登録されている管理者が1件の場合' do
        it '一覧画面にユーザ削除失敗のメッセージが表示される' do
          page.accept_confirm do
            all(:link, '削除')[1].click
          end
          expect(page).to have_content '他に管理者ユーザが存在しないため削除できません'
          expect(User.admin.size).to eq 1
        end
      end
    end
  end
end
