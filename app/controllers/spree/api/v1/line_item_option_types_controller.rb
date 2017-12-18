module Spree
  module Api
    module V1
      class LineItemOptionTypesController < Spree::Api::BaseController
        def index
          if params[:ids]
            @line_item_option_types = Spree::LineItemOptionType.includes(:line_item_option_values).accessible_by(current_ability, :read).where(id: params[:ids].split(','))
          else
            @line_item_option_types = Spree::LineItemOptionType.includes(:line_item_option_values).accessible_by(current_ability, :read).load.ransack(params[:q]).result
          end
          respond_with(@line_item_option_types)
        end

        def show
          @line_item_option_type = Spree::LineItemOptionType.accessible_by(current_ability, :read).find(params[:id])
          respond_with(@line_item_option_type)
        end

        def create
          authorize! :create, Spree::LineItemOptionType
          @line_item_option_type = Spree::LineItemOptionType.new(line_item_option_type_params)
          if @line_item_option_type.save
            render :show, :status => 201
          else
            invalid_resource!(@line_item_option_type)
          end
        end

        def update
          @line_item_option_type = Spree::LineItemOptionType.accessible_by(current_ability, :update).find(params[:id])
          if @line_item_option_type.update_attributes(line_item_option_type_params)
            render :show
          else
            invalid_resource!(@line_item_option_type)
          end
        end

        def destroy
          @line_item_option_type = Spree::LineItemOptionType.accessible_by(current_ability, :destroy).find(params[:id])
          @line_item_option_type.destroy
          render :text => nil, :status => 204
        end

        private

        def line_item_option_type_params
          params.require(:line_item_option_type).permit([:id, :name, :presentation, :position])
        end
      end
    end
  end
end