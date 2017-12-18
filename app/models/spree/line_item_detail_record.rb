module Spree
  class LineItemDetailRecord < Spree::Base
    belongs_to :line_item, class_name: 'Spree::LineItem', touch: true, inverse_of: :line_item_detail_records
    acts_as_list scope: :line_item

    has_many :line_item_option_value_detail_records, class_name: 'Spree::LineItemOptionValueDetailRecord', dependent: :destroy
    has_many :line_item_option_values, through: :line_item_option_value_detail_records, class_name: 'Spree::LineItemOptionValue'

    accepts_nested_attributes_for :line_item_option_value_detail_records
  end
end