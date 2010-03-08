xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rows do
  xml.page 0
  xml.total 1
  xml.records @project_roles.size
  @project_roles.each_with_index do |item, index|
    xml.row :id => index do
      xml.cell (index + 1)
      xml.cell item[:user_name]
      xml.cell item[:role_name]
      xml.cell link_to "<span class=\"ui-icon ui-icon-closethick\">", admin_project_destroy_role_path(:user_id => item[:user_id], :role => item[:role]), :confirm => t("messages.are_you_shure"), :method => :delete, :title => t("actions.destroy_role")
    end
  end
end

