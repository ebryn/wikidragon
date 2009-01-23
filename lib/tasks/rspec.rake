desc "Run the rspec story runner stories"
task :stories do
  RAILS_ENV = ENV['RAILS_ENV'] = 'test'
  sh "ruby #{RAILS_ROOT}/stories/all.rb"
end

desc "Run all tests, including stories"
task :all => %w[ spec stories ] 

