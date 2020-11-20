require 'rails_helper'

RSpec.describe "Admin Users", type: :request do

  describe "DELETE /admin/users/:id" do
    let(:user) { create(:user) }
    let(:member) { create(:user, role: User.roles[:member]) }

    it 'cannot delete the last admin user' do
      params = { session: { username: user.email, password: user.password } }
      post login_path, params: params
      delete admin_user_path(user)

      expect(response.body).to include I18n.t('admin.users.notice_cannot_delete_the_last_admin')
    end

  end

end
