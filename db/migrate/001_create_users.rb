class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |table|
      table.column :name, :string
    end
  end

  def self.down
    drop_table :users
  end
end
