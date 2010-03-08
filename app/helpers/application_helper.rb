# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper

    # Gets menu items in format: [title, url, is_current block].
    def menu_items
        menu = []
        menu.push([t("menu.home"), home_path, Proc.new {controller_name == "home"}])
        if current_user
            menu.push([t("menu.profile"), profile_path, Proc.new {controller_name == "profile"}])
            menu.push([t("menu.logout"), logout_path])
        else
            menu.push([t("menu.register"), register_path, Proc.new {controller_name == "registration"}])
        end
        menu
    end

    # Gets menu items for admin area in format: [title, url, is_current block].
    def admin_menu_items
        menu = []
        menu.push([t("menu.home"), admin_home_path, Proc.new {controller_name == "home"}])
        if current_user
            menu.push([t("menu.projects"), admin_projects_path, Proc.new {controller_name == "projects" || controller_name == "project_to_users"}])
            menu.push([t("menu.users"), admin_users_path, Proc.new {controller_name == "users"}])
            menu.push([t("menu.profile"), admin_profile_path, Proc.new {controller_name == "profile"}])
            menu.push([t("menu.logout"), logout_path])
        end
        menu
    end
end

ActionView::Base.default_form_builder = CustomFormBuilder

