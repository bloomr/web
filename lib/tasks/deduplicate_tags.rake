namespace :deduplicate {
  task tags: :environment do
    all_keywords = Keyword.group(:normalized_tag).count
    duplicates = all_keywords
      .select { |_k, v| v > 1 }
      .map { |k, _v| Keyword.includes(:users).where(normalized_tag: k).to_a }

    duplicates.each do |keywords|
      description = keywords.map(&:description).compact.find(&:present?)
      ordered_k = keywords.sort_by { |k| k.users.count }

      most_populare = ordered_k.pop
      most_populare.update_attribute(:description, description)
      ordered_k.each do |to_remove|
        to_remove.users.each do |user|
          user.keywords.delete(to_remove)
          user.keywords << most_populare
        end
        to_remove.destroy
      end
    end
  end
}
