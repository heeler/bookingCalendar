load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

after 'deploy:symlink', 'deploy:finishing_touches'

namespace :deploy do
   task :finishing_touches, :roles => :app do
		run "rm -rf #{current_path}/vendor/plugins/open_id_authentication"
		run "ln -s #{deploy_to}/shared/vendor/plugins/open_id_authentication #{current_path}/vendor/plugins/"
		run "rm -rf #{current_path}/db/production.sqlite3"
		run "ln -s #{deploy_to}/shared/system/production.sqlite3 #{current_path}/db/"
  end

	 task :start, :roles => :app do
	   run "touch #{current_release}/tmp/restart.txt"
	 end

	 task :stop, :roles => :app do
	   # Do nothing.
	 end

	 desc "Restart Application"
	 task :restart, :roles => :app do
	   run "touch #{current_release}/tmp/restart.txt"
	 end


end