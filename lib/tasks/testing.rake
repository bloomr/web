namespace :testing do
  desc 'build client app'
  task build_client: :environment do
    puts `npm install`
  end

  desc 'build and tests everything'
  task all: [:build_client, :spec] do
  end
end
