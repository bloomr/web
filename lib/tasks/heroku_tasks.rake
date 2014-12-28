namespace :heroku do
	desc 'Pull most recent DB from Heroku and dump into localhost'
	task :db_pull => :environment do
		heroku_app = "bloomr"
		local_db = "postgres"
    system "heroku pgbackups:capture --expire --app #{heroku_app}"
    system "curl -o latest.dump `heroku pgbackups:url --app #{heroku_app}`"
    system "pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{local_db} latest.dump"
	end
end