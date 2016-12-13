# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://www.bloomr.org'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                         aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                         aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                         fog_directory: ENV['S3_BUCKET_NAME'],
                                         fog_region: ENV['S3_REGION'])

# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  User.where(published: true).each { |u| add(job_vanity_path(u.to_param)) }
  Tribe.all.each { |t| add(tribe_path(t.normalized_name)) }

  keyword_ids = KeywordAssociation
                .select('keyword_id')
                .group(:keyword_id)
                .having('count(keyword_id) > 2')
                .pluck('keyword_id')
  Keyword.find(keyword_ids).each { |k| add(tag_path(k.tag)) }

  one_pages = %w(press concept bloomifesto qui_sommes_nous testimonies program)
  one_pages.each { |path| add(send(path + '_path')) }
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
