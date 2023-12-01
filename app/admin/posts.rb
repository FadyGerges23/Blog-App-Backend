ActiveAdmin.register Post do

  permit_params :title, :body, :created_at, :user_id, :category_id, tag_ids: []

  index do
    selectable_column
    id_column
    column :title
    column :body
    column :category
    column :tags
    column :user
    column :created_at
    actions
  end

  filter :title
  filter :body
  filter :category
  filter :tags_id, as: :check_boxes, collection: proc { Tag.all.map { |tag| [tag.name, tag.id] } }, label: 'Tags'
  filter :created_at

  show do
    attributes_table do
      row :title
      row :body
      row :category
      row :tags
      row :user
      row :created_at
    end
    active_admin_comments
  end
  
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :category
      f.input :tags, as: :check_boxes
      if f.object.new_record?
        f.input :user
      end
    end
    f.actions
  end
  
end
