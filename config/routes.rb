ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  map.root :controller => 'nodes'

  # note that starting with a captial letter is the only way to distinguish these links from controller/action links
  # matches (eg) /nodes/Trust Exchange/ 
  map.connect 'nodes/:title', :controller => 'nodes', :action => 'show', :requirements => { :title => %r{[A-Z][^/]+} }       
  # matches (eg) /Trust Exchange/ 
  map.connect '/:title',       :controller => 'nodes', :action => 'show', :requirements => { :title => %r{[A-Z][^/]+} }

  map.nodes '/nodes/:id', :controller => 'nodes', :action => 'show', :requirements => { :id => /\d+/ }

  map.resources :remote_node
  map.connect 'remote_node/:url/edit', :controller => 'remote_node', :action => 'edit', :requirements => { :url => %r{https?%3A%2F%2F[^/]+} }       

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
