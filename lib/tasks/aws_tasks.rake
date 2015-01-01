namespace :aws do
  desc 'sync from local folder to s3'
  task :s3_push => :environment do
    bucket_name = ENV['bucket_name']
    system "aws s3 sync #{bucket_name}/ s3://#{bucket_name} --recursive --acl public-read --delete --exclude=*DS_Store"
  end
end