Spree::LineItem.class_eval do
  has_many :line_item_detail_records, class_name: 'Spree::LineItemDetailRecord', dependent: :destroy
  accepts_nested_attributes_for :line_item_detail_records

  # commented out due to: issue with spree_sample:load
  # validates :line_item_option_values, presence: true

  # commented out due to: ransack issue on :3000/spree/admin
  # self.whitelisted_ransackable_associations = %w[option_values line_item_option_values product prices default_price]

#  def line_item_options_text
#    values = self.line_item_option_values.sort do |a, b|
#      a.line_item_option_type.position <=> b.line_item_option_type.position
#    end
#
#    values.to_a.map! do |liov|
#      "#{liov.line_item_option_type.presentation}: #{liov.presentation}"
#    end
#
#    values.to_sentence({ words_connector: ", ", two_words_connector: ", " })
#  end
#
#  def descriptive_name
#    variant.product.name + ' - ' + line_item_options_text
#  end
#
#  def line_item_options=(line_item_options = {})
#    line_item_options.each do |line_item_option|
#      set_line_item_option_value(line_item_option[:name], line_item_option[:value])
#    end
#  end
#
#  def set_line_item_option_value(line_item_opt_name, line_item_opt_value)
#    # no line_item_option values on master
#    # return if self.is_master
#
#    line_item_option_type = Spree::LineItemOptionType.where(name: line_item_opt_name).first_or_initialize do |lio|
#      lio.presentation = line_item_opt_name
#      lio.save!
#    end
#
#    current_value = self.line_item_option_values.detect { |o| o.line_item_option_type.name == line_item_opt_name }
#
#    unless current_value.nil?
#      return if current_value.name == line_item_opt_value
#      self.line_item_option_values.delete(current_value)
#    else
#      # then we have to check to make sure that the product has the line item option type
#      unless self.variant.product.line_item_option_types.include? line_item_option_type
#        self.variant.product.line_item_option_types << line_item_option_type
#      end
#    end
#
#    line_item_option_value = Spree::LineItemOptionValue.where(line_item_option_type_id: line_item_option_type.id, name: line_item_opt_value).first_or_initialize do |lio|
#      lio.presentation = line_item_opt_value
#      lio.save!
#    end
#
#    self.line_item_option_values << line_item_option_value
#    self.save
#  end
#
#  def line_item_option_value(line_item_opt_name)
#    self.line_item_option_values.detect { |lio| lio.line_item_option_type.name == line_item_opt_name }.try(:presentation)
#  end
end