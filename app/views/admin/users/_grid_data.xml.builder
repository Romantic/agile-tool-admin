xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rows do
  xml.page @page
  xml.total @totalPages
  xml.records @total
  @users.each_with_index do |user, index|
    xml.row :id => user.id do
      xml.cell ((@page - 1) * @pageSize + (index + 1))
      xml.cell h(user.full_name)
      xml.cell h(user.email)
      xml.cell admin_user_path(:id => user.id)
      xml.cell edit_admin_user_path(:id => user.id)
    end
  end
end