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

  permit_params :email, :password, :password_confirmation, :first_name, :job_title, :avatar,
                :keyword_list, :published,
                questions_attributes: [:id, :title, :answer, :identifier, :_destroy]

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete "password"
        params[:user].delete "password_confirmation"
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :job_title
    column :first_name
    column :created_at
    column :current_sign_in_at
    column :published
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :published

  form do |f|
    f.inputs "Credentials" do
      f.input :email
      f.input :password, :required => false, :hint => "You can leave it empty to prevent changing the user's existing password. New users should have a password."
      f.input :password_confirmation, :required => false
    end

    f.inputs "Infos" do
      f.input :first_name
      f.input :job_title
      f.input :avatar, :required => false, :as => :file, :hint => f.template.image_tag(f.object.avatar.url(:thumb))
      f.input :published
    end

    f.inputs "Keywords" do
      f.input :keyword_list, :hint => "Keywords should be separated by commas ','."
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
