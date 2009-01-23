class Nodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do | table |
      table.column :title,    :string
      table.column :content,  :text
      table.references :user
    end
  end

  def self.down
    drop_table :nodes 
  end
end
