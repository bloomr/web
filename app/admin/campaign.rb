ActiveAdmin.register Campaign do
  permit_params :id, :partner, :campaign_url,
                campaignsProgramTemplates_attributes: [
                  :id, :campaign_id, :program_template_id, :price, :_destroy
                ]

  index do
    id_column
    column :partner
    column :campaign_url
    actions
  end

  filter :partner

  form do |f|
    f.inputs 'Campaign' do
      f.input :partner
      f.input :campaign_url
      f.has_many :campaignsProgramTemplates, heading: 'Program Templates', allow_destroy: true do |a|
        a.input :program_template_id, label: 'program', as: :select, collection: ProgramTemplate.all.map { |p| [p.name, p.id] }
        a.input :price
      end
    end
    f.actions
  end
end
