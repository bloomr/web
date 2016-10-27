class CreateAdminEmailCampaigns < ActiveRecord::Migration
  def change
    create_table :admin_email_campaigns do |t|
      t.string :template_name
      t.string :var1_name, default: 'first_name'
      t.string :var1_value, default: 'first_name'
      t.string :var2_name
      t.string :var2_value
      t.string :var3_name
      t.string :var3_value
      t.string :recipients
      t.boolean :published_bloomeurs, default: false
      t.boolean :finished, default: false
      t.text :logs_text

      t.timestamps null: false
    end
  end
end
