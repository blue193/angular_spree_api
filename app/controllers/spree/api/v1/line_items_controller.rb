# Changes: LineItemDetailRecord

module Spree
  module Api
    module V1
      class LineItemsController < Spree::Api::BaseController
        class_attribute :line_item_options

        self.line_item_options = []

        def create
          variant = Spree::Variant.find(params[:line_item][:variant_id])
          @line_item = order.contents.add(
              variant,
              params[:line_item][:quantity] || 1,
              line_item_params[:options] || {}
          )

          # create lidr for each quantity
          # TODO: move logic to model
          if @line_item.errors.empty?
            (1..@line_item.quantity).each do |position|
              lidr = @line_item.line_item_detail_records.create
            end
          end

          # if there are lidr attributes in params, save data (used in API)
          if @line_item.errors.empty? && line_item_params[:line_item_detail_records_attributes]
            line_item_params[:line_item_detail_records_attributes].each do |lidra|
              lidr = @line_item.line_item_detail_records.find_by_position(lidra[:position])

              lidra[:line_item_option_value_detail_records_attributes].each do |liovdra|
                lidr.line_item_option_value_detail_records.create(line_item_option_value_id: liovdra[:line_item_option_value_id])
              end
            end

          # if there are none, create liovdr records from default values (used in Admin)
          # TODO: move logic to model...?
          else
            liots = @line_item.product.line_item_option_types

            (1..@line_item.quantity).each do |position|
              lidr = @line_item.line_item_detail_records.find_by_position(position)

              liots.each do |liot|
                lidr.line_item_option_value_detail_records.create(line_item_option_value_id: liot.line_item_option_values.first.id)
              end
            end
          end

          if @line_item.errors.empty?
            respond_with(@line_item, status: 201, default_template: :show)
          else
            invalid_resource!(@line_item)
          end
        end

        def update
          @line_item = find_line_item
          if @order.contents.update_cart(line_items_attributes)
            @line_item.reload

            # if items were removed, remove extra lidr
            # TODO: move logic to model
            if @line_item.quantity < @line_item.line_item_detail_records.count
              Spree::LineItemDetailRecord.where("line_item_id = ? AND position > ?", @line_item.id, @line_item.quantity).destroy_all
            end

            # if items were added, add new lidr
            # TODO: move logic to model
            if @line_item.quantity > @line_item.line_item_detail_records.count
              # TODO: reuse logic from #create
              liots = @line_item.product.line_item_option_types

              ((@line_item.line_item_detail_records.count + 1)..@line_item.quantity).each do |new_position|
                lidr = @line_item.line_item_detail_records.create(position: new_position)

                liots.each do |liot|
                  lidr.line_item_option_value_detail_records.create(line_item_option_value_id: liot.line_item_option_values.first.id)
                end
              end

            end

            # save lidr
            if @line_item.errors.empty? && line_item_params[:line_item_detail_records_attributes]

              lidras = turnToArray(line_item_params[:line_item_detail_records_attributes])

              # edit each li
              lidras.each do |lidra|

                lidr = @line_item.line_item_detail_records.find_by_position(lidra[:position])

                # Edge case: when items are added (new quantity is higher), skip liovdr update (details not included in POST)
                if lidra[:line_item_option_value_detail_records_attributes]

                  liovdras = turnToArray(lidra[:line_item_option_value_detail_records_attributes])

                  # edit each lidr
                  liovdras.each do |liovdra|

                    liovdr = lidr.line_item_option_value_detail_records.find_by_id(liovdra[:id])

                    unless liovdr.update(liovdra)
                      invalid_resource!(@line_item)
                      return
                    end

                    # # For now, allow liovdrd update (creation / deletion) on separate API calls
                    # # reason: encoding to base64 on the client side can only be done in async;
                    # #         since this #update function is run in client-side sync, refactoring to async bloats original code
                    # if liovdr.errors.empty?
                    #
                    #   # (previous attachments can only be deleted through separate API call)
                    #   if liovdr.line_item_option_value.line_item_option_type.file?
                    #     document_data = turnToArray(liovdra[:document_data])
                    #
                    #     document_data.each do |doc|
                    #       uploaded_document = liovdr.line_item_option_value_detail_record_documents.build(name: doc[:name], file_base: doc[:file_base])
                    #       uploaded_document.save
                    #
                    #       unless uploaded_document.errors.empty?
                    #         invalid_resource!(@line_item)
                    #         return
                    #       end
                    #     end
                    #   end
                    #
                    # else

                  end

                end

              end

            end

            respond_with(@line_item, default_template: :show)
          else
            invalid_resource!(@line_item)
          end
        end

        def destroy
          @line_item = find_line_item
          @order.contents.remove_line_item(@line_item)
          respond_with(@line_item, status: 204)
        end

        private

        # warning: input from admin is transformed by CoffeeScript from object array to hash
        # approach: if request is generated from admin (by Coffeescript), transform hash to object array
        # returns input if safe to use
        def turnToArray(input)
          result = []

          if input.instance_of? ActionController::Parameters
            input.each do |k,v|
              result.push(v)
            end
            result
          else
            result = input
          end
        end

        def order
          @order ||= Spree::Order.includes(:line_items).find_by!(number: order_id)
          authorize! :update, @order, order_token
        end

        def find_line_item
          id = params[:id].to_i
          order.line_items.detect { |line_item| line_item.id == id } or
              raise ActiveRecord::RecordNotFound
        end

        def line_items_attributes
          {
            line_items_attributes: {
              id: params[:id],
              quantity: params[:line_item][:quantity],
              options: line_item_params[:options] || {}
            }
          }
        end

        # add LineItemDetailRecord
        def line_item_params
          params.require(:line_item).permit(
            :quantity,
            :variant_id,

            line_item_detail_records_attributes: [
              :position,
              line_item_option_value_detail_records_attributes: [
                :id,
                :line_item_option_value_id,
                :text,
                document_data: [
                  :id,
                  :name,
                  :file_base
                ]
              ]
            ],

            options: line_item_options
          )
        end
      end
    end
  end
end
