def create_user( params = {} )
  params = { :name => "Jim Smith #{random}" }.merge( params )
  User.create!( params )
end

def create_node( params = {} )
  Node.create!( node_params( params ) )
end

def node_params( params = {} )
  { :title => 'Trust Exchange',
      :content => 'Fixing democracy and capitalism with trust...',
      :user => create_user }.merge( params )
end

def random
  rand.to_s.split('.').last
end