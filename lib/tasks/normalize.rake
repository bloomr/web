class Normalize
  def self.keywords
    User.all.each do |u|
      u.keywords.each do |k|
        capitalized_tag = k.tag.mb_chars.capitalize.to_s
        next unless k.tag != capitalized_tag
        capitalized_keyword = Keyword.find_by(tag: capitalized_tag)
        if capitalized_keyword.nil?
          k.tag = capitalized_tag
          k.save
        else
          u.keywords << capitalized_keyword
          u.keywords.delete(k)
          u.save
        end
      end
    end

    Keyword.all.each do |k|
      k.destroy if k.tag != k.tag.mb_chars.capitalize.to_s
    end
  end
end

namespace :normalize do
  task keywords: :environment do
    Normalize.keywords
  end
end
