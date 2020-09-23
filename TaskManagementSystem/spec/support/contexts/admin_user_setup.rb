RSpec.shared_context "admin_user_setup" do
  let!(:admin_user) { create(:login_user, id: 1) }
  let!(:admin_role) { create(:role, id: 1) }
  let!(:admin_user_role) {create(:user_role, user_id: 1, role_id: 1)}
end