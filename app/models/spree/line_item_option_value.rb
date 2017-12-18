module Spree
  class LineItemOptionValue < Spree::Base
    belongs_to :line_item_option_type, class_name: 'Spree::LineItemOptionType', touch: true, inverse_of: :line_item_option_values
    acts_as_list scope: :line_item_option_type

    has_many :line_item_option_value_detail_records, class_name: 'Spree::LineItemOptionValueDetailRecord'
    has_many :line_item_detail_records, through: :line_item_option_value_detail_records, class_name: 'Spree::LineItemDetailRecord'

    with_options presence: true do
      validates :name, uniqueness: { scope: :line_item_option_type_id, allow_blank: true }
      validates :presentation
    end

    after_touch :touch_all_detail_records

    delegate :name, :presentation, :position, to: :line_item_option_type, prefix: true, allow_nil: true

    self.whitelisted_ransackable_attributes = ['presentation']

    private

    def touch_all_detail_records
      detail_records.update_all(updated_at: Time.current)
    end
  end
end