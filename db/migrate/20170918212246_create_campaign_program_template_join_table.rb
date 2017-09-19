class CreateCampaignProgramTemplateJoinTable < ActiveRecord::Migration
  def change
    create_table :campaigns_program_templates do |t|
      t.column :price, :decimal, null: false
      t.belongs_to :campaign, index: true
      t.belongs_to :program_template, index: true
      t.timestamps
      t.index [:campaign_id, :program_template_id], unique: true, name: 'campaigns_program_template_index'
    end
  end
end
