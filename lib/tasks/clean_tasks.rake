namespace :clean do
  desc 'clean keyword by trying to remove double'
  task keywords: :environment do
    normalized_tags = Keyword.select(:normalized_tag).group(:normalized_tag).having('count(*) >1').pluck(:normalized_tag)
    doubled_keywords = normalized_tags.map { |e| Keyword.where(normalized_tag: e) }

    doubled_keywords.each  do |e|
      break if choose_right(e) == 'quit'
    end
  end

  def choose_right(keywords)
    puts 'choose wisely, s for skip, q for quit'

    keywords.each.with_index do |e, i|
      puts "#{i}, #{e.tag}"
    end

    input = STDIN.gets.strip
    if input == 's'
      puts 'skipped'
    elsif input == 'q'
      puts 'quit'
      return 'quit'
    else
      index = input.to_i
      puts "you have selected #{keywords[index]}"
      merge_keywords keywords[index], keywords
    end
    'next'
  end

  def merge_keywords(selected, keywords)
    keywords_to_replaces = keywords - [selected]
    keywords_to_replaces.each do |to_replace|
      kas = KeywordAssociation.where(keyword: to_replace)
      kas.each do |ka|
        ka.keyword = selected
        ka.save
      end
      to_replace.delete
    end
  end
end
