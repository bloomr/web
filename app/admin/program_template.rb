ActiveAdmin.register ProgramTemplate do
  permit_params :name, :discourse, :intercom, :_destroy

  index do
    selectable_column
    id_column
    column :name
    column :discourse
    column :intercom
    actions
  end

  filter :name

  form do |f|
    f.inputs 'Program' do
      f.input :name
      f.input :discourse
      f.input :intercom
      f.actions
    end
  end
end
