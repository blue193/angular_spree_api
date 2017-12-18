module Spree
  class LineItemOptionValueDetailRecordDocument < Spree::Base
    before_validation :parse_file

    belongs_to :line_item_option_value_detail_record, class_name: 'Spree::LineItemOptionValueDetailRecord'

    has_attached_file :file
    validates_attachment_file_name :file, matches: [
                                                                /png\z/,
                                                                /jpe?g\z/,
                                                                /stl\z/,
                                                                /obj\z/,
                                                                /zip\z/,
                                                                /dcm\z/,
                                                                /3oxz\z/
                                                              ]
    # do_not_validate_attachment_file_type :file

    attr_accessor :file_base, :upload_file_name

    private
      def parse_file
        file_from_base = Paperclip.io_adapters.for(file_base)
        file_from_base.original_filename = @upload_file_name
        self.file = file_from_base
      end
  end
end
