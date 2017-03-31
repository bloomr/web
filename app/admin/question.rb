ActiveAdmin.register Question do
  scope :first_interview_canonicals
  permit_params :title, :answer, :published, :description, :mandatory

  index do
    selectable_column
    id_column
    column :user
    column :title
    column :mandatory
    column :answer
    column :description
    column :position
    column :published
  end

  filter :user
  filter :title
  filter :published

  form do |f|
    f.inputs 'User' do
      f.input :user, input_html: { disabled: true }
    end

    f.inputs 'General' do
      f.input :title
      f.input :mandatory
      f.input :answer
      f.input :description
      f.input :position
      f.input :published
    end

    f.actions
  end
end
