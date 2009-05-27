class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.integer :person_id
      t.string :name
      t.integer :pages
      t.float :price
      t.datetime :invoiced_at
      t.date :purchased_on
      t.timestamp :paid_at
      t.time :checkin
      t.text :description
      t.boolean :paperback

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
