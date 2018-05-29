ActiveAdmin.register Campaign do
  permit_params :id, :partner, :campaign_url,
                bundles_campaigns_attributes: [
                  :id, :bundle_id, :price, :_destroy
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
      f.has_many :bundles_campaigns, heading: 'Bundles', allow_destroy: true do |a|
        a.input :bundle_id, label: 'bundle', as: :select, collection: Bundle.all.map { |p| [p.name, p.id] }
        a.input :price
      end
    end
    f.actions
  end
end
