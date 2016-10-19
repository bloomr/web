ActiveAdmin.register Testimony do
  permit_params :title, :body, :person, :date, :position

  index do
    selectable_column
    id_column
    column :title
    column :body
    column :person
    column :date
    column :position
    actions
  end

  filter :title
  filter :body
  filter :person

  form do |f|
    f.inputs 'Bloomy' do
      f.input :title
      f.input :body
      f.input :person
      f.input :date
      f.input :position
    end
    f.actions
  end
end
