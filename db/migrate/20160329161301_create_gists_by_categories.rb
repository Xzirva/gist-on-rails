class CreateGistsByCategories < ActiveRecord::Migration
  def change
    create_table :gists_by_categories do |t|
      t.string :gist_id, null: false
      t.references :category, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
