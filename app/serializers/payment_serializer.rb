class PaymentSerializer < BaseSerializer
  attributes :id, :source_type, :source_id, :amount, :display_amount,
             :payment_method_id, :response_code, :state, :avs_response,
             :created_at, :updated_at

  has_one :payment_method, serializer: PaymentMethodSerializer
  has_one :source, serializer: PaymentSourceSerializer
end