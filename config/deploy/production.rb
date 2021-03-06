require File.join(File.dirname(__FILE__),'..','..','db','fixture_manifest.rb')
role :app, "67.23.10.10"
role :web, "67.23.10.10"
role :db,  "67.23.10.10", :primary => true

set :db_user, "madracingmx"
set :db_pass, "m4drac1ngmx"
set :mail_user, 'do-not-reply'
set :mail_password, 'm4drac1ngmx'

set :branch, "production"

set :rails_env, "production"

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
namespace :sitemap do

  desc "Copy the sitemap files after deploy"
  task :copy_sitemap, :roles => :app do
    puts "copying Rails sitemap files"
    run("cp #{previous_release}/public/sitemap.xml #{current_release}/public/sitemap.xml")
  end

  after :deploy, 'sitemap:copy_sitemap'
end
