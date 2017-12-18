module Spree
  module Admin
    class LineItemOptionTypesController < ResourceController
      before_action :setup_new_line_item_option_value, only: :edit

      def create
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params
        if @object.save
          invoke_callbacks(:create, :after)
          flash[:success] = flash_message_for(@object, :successfully_created)

          # if input_type is != 'selection', create default liov
          # TODO: handle errors
          unless @object.selection?
            @object.line_item_option_values.create(name: @object.input_type, presentation: @object.input_type)
          end

          respond_with(@object) do |format|
            format.html { redirect_to location_after_save }
            format.js   { render :layout => false }
          end
        else
          invoke_callbacks(:create, :fails)
          respond_with(@object) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def update_values_positions
        ActiveRecord::Base.transaction do
          params[:positions].each do |id, index|
            Spree::LineItemOptionValue.where(id: id).update_all(position: index)
          end
        end

        respond_to do |format|
          format.html { redirect_to admin_product_variants_url(params[:product_id]) }
          format.js { render text: 'Ok' }
        end
      end

      protected
        def location_after_save
          if @line_item_option_type.created_at == @line_item_option_type.updated_at
            edit_admin_line_item_option_type_url(@line_item_option_type)
          else
            admin_line_item_option_types_url
          end
        end

      private
        def load_product
          @product = Product.friendly.find(params[:product_id])
        end

        def setup_new_line_item_option_value
          @line_item_option_type.line_item_option_values.build if @line_item_option_type.line_item_option_values.empty?
        end

        def set_available_line_item_option_types
          @available_line_item_option_types = if @product.line_item_option_type_ids.any?
                                      LineItemOptionType.where.not(id: @product.line_item_option_type_ids)
                                    else
                                      LineItemOptionType.all
                                    end
        end
    end
  end
end
