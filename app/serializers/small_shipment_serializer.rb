class SmallShipmentSerializer < BaseSerializer
  attributes :id, :tracking, :number, :cost, :shipped_at, :state

  attributes :order_id, :stock_location_name

  def order_id
    object.order.number
  end

  def stock_location_name
    object.stock_location.name
  end

  has_one :selected_shipping_rate,
          serializer: ShippingRateSerializer
  has_many :shipping_rates,
           serializer: ShippingRateSerializer

  has_many :adjustments, serializer: AdjustmentSerializer

  has_many :shipping_methods, serializer: ShippingMethodSerializer

  # TODO: Need to figure out how to serialize the manifest
  # has_one :manifest, key: :manifest,
  #                    serializer: Sprangular::ManifestSerializer
  #
  # def manifest
  # end
end