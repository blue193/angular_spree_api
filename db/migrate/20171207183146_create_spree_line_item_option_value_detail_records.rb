class CreateSpreeLineItemOptionValueDetailRecords < ActiveRecord::Migration
  def change
    create_table :spree_line_item_option_value_detail_records do |t|
      t.references :line_item_detail_record,  foreign_key: true
      t.references :line_item_option_value,   foreign_key: true

      t.string :text

      t.timestamps null: false
    end

    # create manually; auto-generated index name exceeds 62 chars
    add_index "spree_line_item_option_value_detail_records", ["line_item_detail_record_id"], name: "index_spree_li_ov_drs_on_li_dr_id"
    add_index "spree_line_item_option_value_detail_records", ["line_item_option_value_id"], name: "index_spree_li_ov_drs_on_li_ov_id"
  end
end
