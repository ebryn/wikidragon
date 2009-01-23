require 'fileutils'

namespace :db do

  desc 'Backup database by mysqldump'
  task :backup => :environment do
    directory = File.join(RAILS_ROOT, 'db', 'backup')
    FileUtils.mkdir directory unless File.exists?(directory)
    require 'yaml'
    db = YAML::load( File.open( File.join(RAILS_ROOT, 'config', 'database.yml') ) )
    db = db[RAILS_ENV]
    timestamp = DateTime.now.to_s
    puts "db password = #{db['password'].inspect}"
    exec "mysqldump #{db['database']} --opt --skip-add-locks -h #{db['host']} -u #{db['username']} -p | gzip > #{directory}/backup_#{timestamp}.sql.gz"
  end

end