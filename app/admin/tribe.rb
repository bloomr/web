ActiveAdmin.register Tribe do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :name, keyword_ids: []

  index do
    id_column
    column :name
    actions
  end

  form do |f|
    f.inputs 'name' do
      f.input :name
    end

    f.inputs 'keywords' do
      f.input :keywords, as: :select2_multiple
    end

    f.actions
  end
end
