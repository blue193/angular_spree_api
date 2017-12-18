module Spree
  class LineItemOptionType < Spree::Base
    acts_as_list

    with_options dependent: :destroy, inverse_of: :line_item_option_type do
      has_many :line_item_option_values, -> { order(:position) }
      has_many :product_line_item_option_types
    end

    has_many :products, through: :product_line_item_option_types

    # has_many :option_type_prototypes, class_name: 'Spree::OptionTypePrototype'
    # has_many :prototypes, through: :option_type_prototypes, class_name: 'Spree::Prototype'

    with_options presence: true do
      validates :name, uniqueness: { allow_blank: true }
      validates :presentation
    end

    enum input_type: [ :selection, :text, :file ]
    enum select_type: [ :button, :dropdown ]

    default_scope { order(:position) }

    accepts_nested_attributes_for :line_item_option_values, reject_if: lambda { |liov| liov[:name].blank? || liov[:presentation].blank? }, allow_destroy: true

    after_touch :touch_all_products

    private

    def touch_all_products
      products.update_all(updated_at: Time.current)
    end
  end
end
