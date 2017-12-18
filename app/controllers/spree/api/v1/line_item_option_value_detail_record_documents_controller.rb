# Changes: LineItemDetailRecord

module Spree
  module Api
    module V1
      class LineItemOptionValueDetailRecordDocumentsController < Spree::Api::BaseController
        def create

          liovdrd = Spree::LineItemOptionValueDetailRecordDocument.new(liodvrd_params)

          if liovdrd.save
            render json: nil, status: 201
          else
            render json: nil, status: 500
          end
        end

        def destroy
          line_item_option_value_detail_record_document = Spree::LineItemOptionValueDetailRecordDocument.find(params[:id])
          line_item_option_value_detail_record_document.destroy
          respond_with(line_item_option_value_detail_record_document, status: 204)
        end

        private

        def liodvrd_params
          params.require(:line_item_option_value_detail_record_document).permit(:name, :upload_file_name, :file_base, :line_item_option_value_detail_record_id)
        end

      end
    end
  end
end
