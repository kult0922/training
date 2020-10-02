# frozen_string_literal: true

ActiveAdmin.register User do
  config.per_page = 5

  # updatable attributes
  permit_params :name, :email, :password

  # search conditions
  filter :id
  filter :name
  filter :email

  # index
  index do
    column :id
    column :name
    column :email
    column :created_at
    column :updated_at
    actions
  end

  # show
  show tittle: 'ユーザの詳細' do
    attributes_table do
      row :id
      row :name
      row :email
      row :created_at
      row :updated_at
    end
  end

  # new/edit
  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs 'ユーザの詳細' do
      f.input :name
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
end
