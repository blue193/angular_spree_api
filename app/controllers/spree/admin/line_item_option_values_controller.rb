module Spree
  module Admin
    class LineItemOptionValuesController < Spree::Admin::BaseController
      def destroy
        line_item_option_value = Spree::LineItemOptionValue.find(params[:id])
        line_item_option_value.destroy
        render text: nil
      end
    end
  end
end
