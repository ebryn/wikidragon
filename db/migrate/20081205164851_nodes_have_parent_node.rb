class NodesHaveParentNode< ActiveRecord::Migration
  def self.up
    add_column :nodes, :parent_id, :integer      # nodes can have parent nodes, thanks to acts_as_tree
  end

  def self.down
    remove_column :nodes, :parent_id
  end
end
