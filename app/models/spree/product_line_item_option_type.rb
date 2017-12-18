module Spree
  class ProductLineItemOptionType < Spree::Base
    with_options inverse_of: :product_line_item_option_types do
      belongs_to :product, class_name: 'Spree::Product'
      belongs_to :line_item_option_type, class_name: 'Spree::LineItemOptionType'
    end
    acts_as_list scope: :product

    validates :product, :line_item_option_type, presence: true
    validates :product_id, uniqueness: { scope: :line_item_option_type_id }, allow_nil: true
  end
end
