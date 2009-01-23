require "#{File.dirname(__FILE__)}/helper"

Story "Creating a new node", %{
  As a node author,
  I want to create a new text article or "node"
  So that I can express myself, and give my gifts to the world
  }, :type => RailsStory do

  Scenario "Create new node" do

    Given "a system with no existing content" do
      Node.all.should be_empty
      User.all.should be_empty
    end

    And "I am logged in" do
      @user = User.create!( :name => 'some user')
      post '/login/login', :user => { :id => @user.id }
      session[ :user_id ].should == @user.id
    end

    When "I create a new node named 'Trust Exchange'" do
      session[ :user_id ].should == @user.id
      post '/nodes/create', :node => { :title => 'Trust Exchange', :content => 'The currency of the future' }
    end

    Then "my node is saved in the system" do
      Node.find(:all).length.should == 1
      Node.find(:first).title.should == 'Trust Exchange'
    end

    And "I am returned to the node list" do
      assert_redirected_to :controller=>"nodes", :action => 'list'
    end

    And 'the node "Trust Exchange" should appear on the node list' do
      follow_redirect!
    end

  end

end

Story "Remixing a node by another user", %{
    As a creative person,
    I want to remix a "node" created by another user
    So that I can improve the content, and be credited for my contribution
    }, :type => RailsStory do

  Scenario "Remix existing node" do

    Given "a system with no existing content" do
      Node.all.should be_empty
      User.all.should be_empty
    end

    And "one node is created: 'Galactivation' by Felix" do
      @author = User.create!( :name => 'Felix')
      @node   = Node.create!( :user_id => @author.id, :title => 'Galactivation', :content => 'Hm, very secret' )
    end

    And "Thomas is logged in" do
      @remixer = User.create!( :name => 'Thomas')
      post '/login/login', :user => { :id => @remixer.id }
      session[ :user_id ].should == @remixer.id
    end

    When "I remix the node to create my own version" do
      post "/nodes/update", :id => @node.id,
          :node => { :title => 'Galactivation', :content => 'All will be revealed' }
    end

    Then 'two nodes should be in the system' do
      Node.find( :all ).length.should == 2
    end

    And "one node should be the original" do
      originals = Node.find( :all, :conditions => { :user_id => @author.id, :content => 'Hm, very secret' } )
      originals.length.should == 1
      @original = originals.first
      @original.should_not be_nil
    end

    And "one node should be the remix  " do
      remixes = Node.find( :all, :conditions => { :user_id => @remixer.id, :content => 'All will be revealed' } )
      remixes.length.should == 1
      remix = remixes.first
      remix.parent.should == @original
    end

  end

  Scenario "Viewing the tree of node remixes" do

    GivenScenario "Remix existing node"     # we created 2 nodes, 1 a remix of the other

    When "I view the list of nodes in the system" do
      get '/nodes/list'
    end

    Then 'the original node should be the only top-level node' do
      assert_select 'ul#all_nodes > li.node', :count => 1
    end

    And 'the remix node should be nested under the original node' do
      assert_select 'li.node', :html => /Galactivation.+by Felix/ do
        assert_select 'ul' do
          assert_select 'li.node', :html => /Galactivation.+by Thomas/
        end
      end
    end

  end

end
