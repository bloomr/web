class PreviousUserDoAuthorize < ActiveRecord::Migration
  def change
    User.where(published: true).update_all(do_authorize: true)
  end
end
