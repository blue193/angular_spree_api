class CreateSpreeLineItemOptionTypes < ActiveRecord::Migration
  def change
    create_table :spree_line_item_option_types do |t|
      t.string :name,         :limit => 100, index: true
      t.string :presentation, :limit => 100
      t.integer :position,    :default => 0, :null => false, index: true

      t.integer :input_type,  :default => 0
      t.integer :select_type, :default => 0
      t.boolean :mandatory, :default => false
      t.string :description

      t.timestamps null: false
    end
  end
end
