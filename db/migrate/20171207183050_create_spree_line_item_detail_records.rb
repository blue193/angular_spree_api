class CreateSpreeLineItemDetailRecords < ActiveRecord::Migration
  def change
    create_table :spree_line_item_detail_records do |t|
      t.integer :position,      index: true

      t.references :line_item,  index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
