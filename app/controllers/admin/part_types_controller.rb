class Admin::PartTypesController < Admin::ResourceController

  model_class PartType
  
  only_allow_access_to :index, :new, :edit, :create, :update, :destroy,
    :when => [:admin],
    :denied_url => '/admin/pages',
    :denied_message => 'You must have admin privileges to perform this action.'

  make_resourceful do
    actions :index, :new, :create, :edit, :update, :destroy
  
    response_for(:create, :update, :destroy, :destroy_fails) do |format|
      format.html { redirect_to admin_templates_path + "#part_types" }
    end
  end

end
