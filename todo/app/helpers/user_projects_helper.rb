module UserProjectsHelper
  def user_project
    @user_have_pj = Array.new
    UserProject.where(user_id: session[:user_id]).each do |user_project|
      @user_have_pj << user_project.project_id
    end
  end
end
