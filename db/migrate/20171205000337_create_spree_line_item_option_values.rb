class CreateSpreeLineItemOptionValues < ActiveRecord::Migration
  def change
    create_table :spree_line_item_option_values do |t|
      t.string :name,                       index: true
      t.string :presentation
      t.integer :position,                  index: true

      t.references :line_item_option_type,  foreign_key: true

      t.timestamps null: false
    end

    # create manually; auto-generated index name exceeds 62 chars
    add_index "spree_line_item_option_values", ["line_item_option_type_id"], name: "index_spree_li_option_values_on_li_option_type_id"
  end
end
