object @line_item_option_value

attributes :id, :name, :presentation, :position, :line_item_option_type_id, :line_item_option_type_name,  :line_item_option_type_presentation, :line_item_option_type_position

node :line_item_option_value_detail_record, if: lambda { |x| x.line_item_option_type.text? } do |liovdr|
  Spree::LineItemOptionValueDetailRecord.where(line_item_detail_record_id: locals[:lidr_id], line_item_option_value_id: locals[:object].id)
end