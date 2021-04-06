module ApplicationHelper
    def task_edit_path(id)
        "edit?id=#{id}"
    end

    def task_destroy_path(id)
        "destroy?id=#{id}"
    end

    def task_list_path()
        "list"
    end
    
    def task_show_path(id)
        "destroy?id=#{id}"
    end
end
