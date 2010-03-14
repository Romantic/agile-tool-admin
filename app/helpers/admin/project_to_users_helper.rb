module Admin::ProjectToUsersHelper
  def add_roles_columns(columns, total_width)
    columns_width = columns.inject(0) {|summ, column| summ + column[:width]}
    role_column_width = (total_width - JqueryGridHelper::DEFAULT_GRID_WIDTH - columns_width) / @roles.size
    @roles.each do |role|
      columns << {
        :field => role,
        :label => Role.human_attribute_name(role),
        :width => role_column_width,
        :sortable => false,
        :align => "center",
        :formatter => :roleFormatter
      }
    end
    columns
  end
end

