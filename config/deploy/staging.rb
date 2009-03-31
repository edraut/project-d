require File.join(File.dirname(__FILE__),'..','..','db','fixture_manifest.rb')
role :app, "67.23.10.10"
role :web, "67.23.10.10"
role :db,  "67.23.10.10", :primary => true

set :db_user, "madracingmx"
set :db_pass, "m4drac1ngmx"
set :mail_user, 'do-not-reply'
set :mail_password, 'm4drac1ngmx'

set :branch, "master"

set :rails_env, "production"
before "deploy:wipe_and_load", "deploy"
namespace :deploy do
  desc "Erase, rebuild, and populate database from schema.rb and fixture files."
  task :wipe_and_load, :roles => :db do
    run("cd #{deploy_to}/current; rake db:wipe_and_load RAILS_ENV=production")
    run("cd #{deploy_to}/shared; tar xzf ../current/public/system.tgz")
  end
end

desc "Export data to fixtures."
task :export_fixtures, :roles => :db do
  
  run("cd #{deploy_to}/current; rake db:export_fixtures RAILS_ENV=production")
  get "#{deploy_to}/current/public/system.tgz", File.join(File.dirname(__FILE__),'..','..','public','system.tgz')
  %x[mkdir #{File.join(File.dirname(__FILE__),'..','..','db','fixtures.bak')}]
  %x[rm -rf #{File.join(File.dirname(__FILE__),'..','..','db','fixtures.bak','*')}]
  %x[mv #{File.join(File.dirname(__FILE__),'..','..','db','fixtures','*')} #{File.join(File.dirname(__FILE__),'..','..','db','fixtures.bak')}]
  for fixture in FixtureManifest.list
    get "#{deploy_to}/current/db/fixtures/#{fixture.to_s}.yml", File.join(File.dirname(__FILE__),'..','..','db','fixtures',fixture.to_s + '.yml')
  end
end
