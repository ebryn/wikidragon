class AddTimestamps < ActiveRecord::Migration
  def self.up
    change_table( :nodes ) { |table| table.timestamps }
    change_table( :users ) { |table| table.timestamps }
  end

  def self.down     
    remove_column :nodes, :created_at
    remove_column :nodes, :updated_at
    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end

