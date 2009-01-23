class NodesController < ApplicationController
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ], :redirect_to => { :action => :list }

  before_filter :identify_user, :except => [ :index, :list, :show ]

  def index
    list
    render :action => 'list'
  end

  #
  # list nodes, in order of relevance to user
  #
  def list
    @nodes = Node.find( :all, :order => 'updated_at DESC', :conditions => ['parent_id IS ?', nil] )    
  end

  def show
    if params[ :id ]
      @node = Node.find( params[ :id ] )
    else
      @node = Node.most_recent_with_title( params[ :title ] )
      if @node == nil
        flash[ :error ] = "No node found with title '#{params[ :title ]}'"
        redirect_to :controller => 'nodes'
      end
    end
  end

  def new
    @node = Node.new
  end

  def create
    @node = Node.new( params[ :node ] )
    @node.user_id = session[ :user_id ]
    if @node.save
      flash[ :notice ] = 'Node was successfully created.'
      redirect_to :action => 'list'
    else
      flash[ :error ] = 'Please enter both a title and content for your Genius Node...'
      render :action => 'new'
    end
  end

  def edit
    @node = Node.find( params[ :id ] )
  end

  def update
    @node = Node.find( params[ :id ] )
    if @node.user_id == session[ :user_id ]
      if @node.update_attributes( params[ :node ] )
        flash[ :notice ] = 'Node was successfully updated.'
        redirect_to :action => 'show', :id => @node
      else
        render :action => 'edit'
      end
    else                    
      remix_node_params = params[ :node ].merge( :user_id => session[ :user_id ] )
      @remix = @node.remix( remix_node_params )
      if @remix.save
        flash[ :notice ] = 'Node was successfully created.'
        redirect_to :action => 'list'
      else
        flash[ :error ] = 'Please enter both a title and content for your Genius Node...'
        render :action => 'update'
      end
    end
  end

  def destroy
    node = Node.find( params[ :id ] )
    if node.user_id == session[ :user_id ] 
      node.destroy
    else
      flash[ :error ] = 'The node you tried to delete was created by another user; please only remove nodes which you created.'
    end
    redirect_to :action => 'list'
  end

end

