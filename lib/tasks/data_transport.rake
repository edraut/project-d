require File.join(RAILS_ROOT, 'db','fixture_manifest.rb')
namespace :db do
  desc "Pretty self explanatory. It erases your entire database and repopulates it."
  task :wipe_and_load => [ 'db:drop', 'db:create', 'db:schema:load', 'db:wipe_and_load:add_attachments', 'db:wipe_and_load:load_fixtures']

  namespace :wipe_and_load do
    desc "Populate attached files"
    task :add_attachments => :environment do
      require 'fileutils'
      FileUtils.chdir(RAILS_ROOT + '/public')
      %x[mv system system.bak]
      %x[tar xzf system.tgz && rm -rf system.bak]
    end

    desc "Load database fixtures."
    task :load_fixtures => :environment do
      require 'active_record/fixtures'

      all_files = Dir.glob(File.join(RAILS_ROOT, 'db', 'fixtures', '*.yml'))
      ordered_files = all_files.select {|path| path =~ /d+_[^.]+.ymlZ/i }
      fixture_files = ordered_files.sort {|x,y| x[/(d+)_.*Z/,1].to_i <=> y[/(d+)_.*Z/,1].to_i }.map { |fixture_path|
        [fixture_path[/(.*).ymlZ/i,1], fixture_path[/d+_([^.]+).ymlZ/i, 1]]
      }
      fixture_files += (all_files - ordered_files).map {|file|
        path = file[0, file.rindex('.')]; [path, File.basename(path)]
      }
      raise "No fixtures found matching \"db/fixtures/*.yml\"!" if fixture_files.empty?

      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

      connection = ActiveRecord::Base.connection

      fixtures = fixture_files.map do |fixture_path, table_name|
        Fixtures.new(connection, table_name, nil, fixture_path)
      end

      connection.transaction(Thread.current['open_transactions'] == 0) do
        fixtures.reverse.each { |fixture| fixture.delete_existing_fixtures }
        fixtures.each { |fixture| fixture.insert_fixtures }

        # Cap primary key sequences to max(pk).
        if connection.respond_to?(:reset_pk_sequence!)
          fixture_files.each do |fixture_path, table_name|
            connection.reset_pk_sequence!(table_name)
          end
        end
      end
    end

  end
  desc "Exports a limited number of records from selected tables to fixtures in /db/fixtures."
  task :export_fixtures => :environment do 

    export_tables = FixtureManifest.template
    puts "Dumping database to activerecord yaml files"
    recursively_write_fixtures(nil,nil,export_tables)
    puts "Database Dumped.\n\n"
    FileUtils.chdir(RAILS_ROOT + '/public')
    %x[tar czf system.tgz system]
  end
end
def recursively_write_fixtures(parent_table,parent_ids,tbl_hash)
  backupdir = RAILS_ROOT + '/db/fixtures'
  FileUtils.mkdir_p(backupdir)
  FileUtils.chdir(backupdir)
  these_ids = {}
  tbl_hash.keys.each{|k| these_ids[k] = []}
  if parent_ids
    parent_table.find(parent_ids).each do |parent_row|
      tbl_hash.keys.map do |sub_tbl|
        if parent_row.respond_to? sub_tbl.to_s.singularize + '_ids'
          these_ids[sub_tbl].push *parent_row.send(sub_tbl.to_s.singularize + '_ids')
        elsif parent_row.respond_to? sub_tbl.to_s.singularize + '_id'
          these_ids[sub_tbl].push parent_row.send(sub_tbl.to_s.singularize + '_id')
        end
      end
    end
  end
  tbl_hash.keys.each do |sub_tbl|
    this_tbl = sub_tbl.to_s.classify.constantize
    puts "Writing #{sub_tbl}..."
    i = "000"
    if parent_ids
      next if these_ids[sub_tbl].empty?
      find_params = [these_ids[sub_tbl]]
    else
      find_params = [:all]
    end
    File.open("#{sub_tbl.to_s}.yml", 'w+') do |file|
      data = this_tbl.find(*find_params)
      file.write data.inject({}) { |hash, record|
        my_record = record.attributes.dup
        unless parent_ids
          these_ids[sub_tbl].push record.id
        end
        hash["#{sub_tbl.to_s}_#{i.succ!}"] = my_record
        hash
      }.to_yaml.sub(/--- \n/,'').sub(/ ![^\n].*/, '')
    end
    unless (tbl_hash[sub_tbl] == 1 or these_ids[sub_tbl].empty?)
      recursively_write_fixtures(this_tbl,these_ids[sub_tbl].uniq,tbl_hash[sub_tbl])
    end
  end
end