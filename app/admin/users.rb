ActiveAdmin.register User do
  permit_params :email, :username, :display_name, :created_at, :password, :password_confirmation, post_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :display_name
    column :created_at
    column :posts
    actions
  end

  filter :email
  filter :display_name
  filter :created_at

  show do
    attributes_table do
      row :email
      row :username
      row :display_name
      row :posts
      row :created_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :display_name

      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
  
end
