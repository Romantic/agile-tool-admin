xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rows do
  xml.page @page
  xml.total @totalPages
  xml.records @total
  @projects.each_with_index do |project, index|
    xml.row :id => project.id do
      xml.cell ((@page - 1) * @pageSize + (index + 1))
      xml.cell h(project.name)
      xml.cell project.start_date ? l(project.start_date, :format => :short) : ""
      xml.cell project.end_date ? l(project.end_date, :format => :short) : ""
      xml.cell admin_project_path(:id => project.id)
      xml.cell edit_admin_project_path(:id => project.id)
    end
  end
end