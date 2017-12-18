Spree::Product.class_eval do
  has_many :product_line_item_option_types, dependent: :destroy, inverse_of: :product
  has_many :line_item_option_types, through: :product_line_item_option_types
end