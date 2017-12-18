class SmallVariantSerializer < BaseSerializer
  attributes :id, :name, :sku, :price, :weight, :height, :width, :depth,
             :is_master, :slug, :description, :track_inventory,
             :display_price, :options_text, :total_on_hand, :product_id,
             :images

  attributes :in_stock, :is_backorderable, :is_destroyed

  has_many :option_values, embed: :objects,
                           serializer: OptionValueSerializer

  has_many :images, embed: :objects,
                    serializer: ImageSerializer

  # rubocop:disable Style/PredicateName
  def in_stock
    object.in_stock?
  end

  def is_destroyed
    object.destroyed?
  end

  def is_backorderable
    object.is_backorderable?
  end
  # rubocop:enable Style/PredicateName
end