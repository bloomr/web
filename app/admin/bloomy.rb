ActiveAdmin.register Bloomy do
  permit_params :email, :first_name, :age, :password

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :age
    column :created_at
    column :current_sign_in_at
    actions
  end

  filter :email
  filter :first_name
  filter :age
  filter :created_at

  form do |f|
    f.inputs 'Bloomy' do
      f.input :email
      f.input :first_name
      f.input :age
      f.input :password
    end
    f.actions
  end

  controller do
    def update
      if params[:bloomy][:password].blank?
        params[:bloomy].delete 'password'
        params[:bloomy].delete 'password_confirmation'
      end
      super
    end
  end
end
