ActiveAdmin.register Bundle do
  permit_params :name, :_destroy,
                program_templates_attributes: [
                  :id, :name, :discourse,
                  :intercom, :_destroy
                ]

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
    end

    panel 'programs' do
      table_for bundle.program_templates do
        column :name
        column :discourse
        column :intercom
      end
    end

  end

  filter :name

  form do |f|
    f.inputs 'Bundle' do
      f.input :name
      f.has_many :program_templates, heading: 'Program Templates', allow_destroy: true do |a|
        a.input :name
        a.input :discourse
        a.input :intercom
      end
    end
    f.actions
  end
end
