module ApplicationHelper
    def tasks_new_path()
        "/tasks/new"
    end

    def tasks_edit_path(id)
        "/tasks/edit?id=#{id}"
    end

    def tasks_destroy_path(id)
        "/tasks/destroy?id=#{id}"
    end

    def tasks_list_path()
        "/tasks/list"
    end
    
    def tasks_show_path(id)
        "/tasks/destroy?id=#{id}"
    end
end
