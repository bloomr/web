class Testimony < ActiveRecord::Base
  has_attached_file :avatar, styles: { thumb: '100x100#' }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  before_post_process :rename_avatar
  def rename_avatar
    extension = File.extname(avatar_file_name).downcase
    avatar.instance_write :file_name, "#{Time.now.to_i}#{extension}"
  end
end
