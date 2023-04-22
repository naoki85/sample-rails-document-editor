class CreateUploadedFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :uploaded_files do |t|
      t.string :file_type, null: false, default: ''
      t.string :file_name, null: false, default: ''
      t.string :file_path, null: false, default: ''
      t.string :workdocs_document_id, null: false, default: ''
      t.string :workdocs_document_version_id, null: false, default: ''

      t.timestamps
    end
  end
end
