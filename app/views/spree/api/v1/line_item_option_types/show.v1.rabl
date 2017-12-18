object @line_item_option_type

attributes :id, :name, :presentation, :position, :input_type, :select_type, :mandatory, :description

child :line_item_option_values => :line_item_option_values do
  attributes :id, :name, :presentation, :position
end