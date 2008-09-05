class TemplatesController < ApplicationController

  only_allow_access_to :index, :new, :edit, :create, :update, :destroy, :move_higher, :move_lower, :move_to_top, :move_to_bottom,
    :when => [:developer, :admin],
    :denied_url => '/admin/pages',
    :denied_message => 'You must have developer privileges to perform this action.'

  make_resourceful do
    actions :index, :new, :create, :edit, :update, :destroy

    response_for(:create, :update, :destroy, :destroy_fails) do |format|
      format.html { redirect_to objects_path }
    end
  end

  # Ordering actions
  %w{move_higher move_lower move_to_top move_to_bottom}.each do |action|
    define_method action do
      load_object
      Template.reordering do
        current_object.send(action)
      end
      request.env["HTTP_REFERER"] ? redirect_to(:back) : redirect_to(objects_path)
    end
  end

  def instance_variable_name
    'content_templates'
  end
end
