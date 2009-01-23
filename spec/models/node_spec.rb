require File.dirname(__FILE__) + '/../spec_helper'

describe Node do

  describe ".new" do
    it "should not have a parent node when newly created" do
      user  = User.create!( :name => 'user' )
      node  = Node.create!( :title => 'node', :content => 'stuff', :user => user )
      node.parent.should be_nil
    end
  end                                        

  describe "associating with a parent node" do
    it "should be the child of its parent node" do
      user  = User.create!( :name => 'user' )
      parent_node = Node.create!( :title => 'x', :content => 'x', :user => user )
      child_node = parent_node.children.create!( :title => 'x', :content => 'x', :user => user )
      child_node.parent.should == parent_node
      parent_node.children.should == [ child_node ]
    end
  end                                        

  describe ".html_content_with_differences" do
    it "should leave html unchanged when diffing against identical node" do
      node1 = Node.new( :title => 'my node', :content => 'stuff' )
      node2 = Node.new( :title => 'my node', :content => 'stuff' )
      node1.content_html.should                                 == '<p>stuff</p>'
      Node.html_content_with_differences( node1, node2 ).should == '<p>stuff</p>'
    end

    it "should produce html ins and del tags representing insertions and deletions" do
      node1 = Node.new( :title => 'my node', :content => 'Stuff and more stuff' )
      node2 = Node.new( :title => 'my node', :content => 'Stuff hurts' )
      Node.html_content_with_differences( node1, node2 ).should ==
          '<p>Stuff <ins>hurts</ins> <del>and more stuff</del></p>'
    end
  end

  describe "#remix" do
    it "should create a new node when remixed" do
      orig_user  = User.create!( :name => 'orig_user' )
      remix_user = User.create!( :name => 'remix_user' )
      orig_node  = Node.create!( :title => 'orig node', :content => 'stuff', :user => orig_user )
      remix_node = orig_node.remix( :title => 'remix node', :content => 'more stuff', :user => remix_user )
      remix_node.reload   # make sure it's saved in the DB
      remix_node.title.should == 'remix node'
      remix_node.content.should == 'more stuff'
      remix_node.user.should == remix_user
      remix_node.parent.should == orig_node
      orig_node.parent.should be_nil
    end
  end

end
