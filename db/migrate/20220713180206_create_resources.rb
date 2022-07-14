class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :ancestry

      t.timestamps
    end
    add_index :resources, :ancestry
  end
end
