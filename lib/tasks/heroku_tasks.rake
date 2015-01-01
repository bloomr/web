namespace :heroku do
	desc 'Pull most recent DB from Heroku and dump into localhost'
	task :db_pull => :environment do
		heroku_app = ENV['heroku_app']
		local_db = "postgres"
    system "heroku pgbackups:capture --expire --app #{heroku_app}"
    system "curl -o latest.dump `heroku pgbackups:url --app #{heroku_app}`"
    system "pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{local_db} latest.dump"
  end

  desc 'Push DB from localhost dump to heroku'
  task :db_push => :environment do
    heroku_app = ENV['heroku_app']
    local_db = "postgres"
    system "aws s3 rm s3://bloomr-data/postgres.dump"
    system "pg_dump -Fc --no-acl --no-owner -h localhost #{local_db} > postgres.dump"
    system "aws s3 cp postgres.dump s3://bloomr-data/postgres.dump --acl public-read"
    system "heroku pgbackups:restore DATABASE 'https://s3-eu-west-1.amazonaws.com/bloomr-data/postgres.dump' --app #{heroku_app} --confirm #{heroku_app}"
  end
end