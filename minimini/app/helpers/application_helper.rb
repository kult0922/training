module ApplicationHelper
    def task_view_path(id)
        "./view?id=#{id}"
    end

    def task_delete_path(id)
        "./destroy?id=#{id}"
    end
    
end
