require 'securerandom'
ActiveAdmin.register Contract do
  permit_params :company_name, :key,
                bundles_contracts_attributes: [:id, :bundle_id, :_destroy]

  index do
    selectable_column
    id_column
    column :company_name
    column :key
    column :created_at
    actions
  end

  filter :company_name

  form do |f|
    f.inputs 'Contract' do
      f.input :company_name
      f.has_many :bundles_contracts, heading: 'Bundles', allow_destroy: true do |a|
        a.input :bundle
      end
    end
    f.actions
  end

  controller do
    def create
      params[:contract][:key] = SecureRandom.hex
      super
    end
  end
end
