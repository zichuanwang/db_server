class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.string :complete_semantic
      t.string :segmented_semantic
      t.string :audio_file_name
      t.string :audio_content_type
      t.integer :audio_file_size
      t.datetime :audio_updated_at
      t.timestamps
    end
  end
end
