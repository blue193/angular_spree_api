module Spree
  class LineItemOptionValueDetailRecord < Spree::Base
    belongs_to :line_item_detail_record, class_name: 'Spree::LineItemDetailRecord'
    belongs_to :line_item_option_value, class_name: 'Spree::LineItemOptionValue'

    has_many :line_item_option_value_detail_record_documents, class_name: 'Spree::LineItemOptionValueDetailRecordDocument', dependent: :destroy

    attr_accessor :document_data
  end
end
