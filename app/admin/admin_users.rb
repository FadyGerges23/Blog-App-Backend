ActiveAdmin.register AdminUser do
  permit_params :email, :created_at, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :created_at
    actions
  end

  filter :email
  filter :created_at

  show do
    attributes_table do
      row :email
      row :created_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email

      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

end
