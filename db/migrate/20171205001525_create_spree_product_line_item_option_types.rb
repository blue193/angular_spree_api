class CreateSpreeProductLineItemOptionTypes < ActiveRecord::Migration
  def change
    create_table :spree_product_line_item_option_types do |t|
      t.integer :position

      t.references :product,                index: true, foreign_key: true
      t.references :line_item_option_type,  foreign_key: true

      t.timestamps null: false
    end

    # create manually; auto-generated index name exceeds 62 chars
    add_index "spree_product_line_item_option_types", ["line_item_option_type_id"], name: "index_spree_product_li_option_types_on_li_option_type_id"
  end
end
