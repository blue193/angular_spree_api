object @line_item_detail_record

attributes :id, :position

child :line_item_option_value_detail_records => :line_item_option_value_detail_records do
  attributes :id
  child :line_item_option_value do
    extends "spree/api/v1/line_item_option_values/show", :locals => { :lidr_id => locals[:object].id }
  end
end