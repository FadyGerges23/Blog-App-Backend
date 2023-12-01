ActiveAdmin.register Tag do

  permit_params :name, :created_at

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  show do
    attributes_table do
      row :name
      row :created_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
  
end
