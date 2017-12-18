class CreateSpreeLineItemOptionValueDetailRecordDocuments < ActiveRecord::Migration
  def change
    create_table :spree_line_item_option_value_detail_record_documents do |t|
      t.references :line_item_option_value_detail_record, foreign_key: true

      t.string :name
      t.attachment :file

      t.timestamps null: false
    end

    # create manually; auto-generated index name exceeds 62 chars
    add_index "spree_line_item_option_value_detail_record_documents", ["line_item_option_value_detail_record_id"], name: "index_spree_li_ov_dr_documents_on_li_ov_dr_id"
  end
end
