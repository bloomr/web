ActiveAdmin.register Bloomy do
  permit_params :email, :first_name, :age, :password

  member_action :journey, method: :post do
    bloomy = Bloomy.find params[:id]
    new_password = WeakPassword.instance
    bloomy.password = new_password
    bloomy.save
    Journey.new(bloomy, new_password)
    redirect_to collection_path,
                notice: "Bloomy ajouté au parcours: #{bloomy.email}"
  end

  action_item :add, only: :show do
    link_to 'Souscrire au parcours',
            journey_admin_bloomy_path(bloomy), method: :post
  end

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
      f.input :password, input_html: { value: 'la fraise rouge' },
                         label: 'Password (default: la fraise rouge)'
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
