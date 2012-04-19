class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :identifier
      t.string :name
      t.string :gender
      t.string :language

      t.timestamps
    end
  end
end
