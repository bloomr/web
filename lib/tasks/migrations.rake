namespace :migrations do
  desc "When ActiveRecord migrations aren't enough..."
  task transform_keywords: :environment do

    # Duplicate the tags in the new keywords table
    tags = ActsAsTaggableOn::Tag.all
    puts "There are #{tags.count} tags to migrate"
    tags.each do |tag|
      Keyword.find_or_create_by(:tag => tag.name)
    end

    # Apply the new keywords to the users
    users = User.all
    puts "There are #{users.count} users to migrate"
    users.each do |user|
      user.keyword_list.each do |old_keyword|
        keyword = Keyword.find_by(:tag => old_keyword)
        KeywordAssociation.find_or_create_by(:user => user, :keyword => keyword)
      end
    end
  end

end
