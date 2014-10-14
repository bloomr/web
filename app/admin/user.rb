ActiveAdmin.register User do


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

  permit_params :email, :first_name, :job_title, :job_description,
                :keyword_list,
                questions_attributes: [:id, :title, :answer, :identifier, :_destroy]

  index do
    selectable_column
    id_column
    column :email
    column :job_title
    column :first_name
    column :created_at
    column :current_sign_in_at
    actions
  end

  filter :email
  filter :current_sign_in_at

  form do |f|
    f.inputs "Credentials" do
      f.input :email
      f.input :password, :required => false
    end

    f.inputs "Infos" do
      f.input :first_name
      f.input :job_title
      f.input :job_description
    end

    f.inputs "Keywords" do
      f.input :keyword_list, :hint => "Keywords should be separated by commas ','"
    end

    f.inputs "Questions" do
      f.has_many :questions, :allow_destroy => true do |qf|
        qf.input :title
        qf.input :answer
        qf.input :identifier
      end
    end

    f.actions
  end

end
