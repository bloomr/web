ActiveAdmin.register Question do

  permit_params :title, :answer, :published

  index do
    selectable_column
    id_column
    column :user
    column :title
    column :answer
    column :published
  end

  filter :user
  filter :title
  filter :published

  form do |f|

    f.inputs "User" do
      f.input :user, :input_html => { :disabled => true }
    end

    f.inputs "General" do
      f.input :title
      f.input :answer
      f.input :published
    end

    f.actions
  end
end