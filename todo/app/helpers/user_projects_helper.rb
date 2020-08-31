module UserProjectsHelper
  def user_project
    @user_have_pj = Array.new
    UserProject.where(user_id: session[:user_id]).each do |user_project|
      @user_have_pj << user_project.project_id
    end
  end

  def check_project
    UserProject.find_by(user_id: session[:user_id], project_id: params[:id])
  end
end
