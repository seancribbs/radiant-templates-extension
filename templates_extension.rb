# Uncomment this if you reference any of your controllers in activate
begin
  require_dependency 'application_controller'
rescue MissingSourceFile
  require_dependency 'application'
end
class TemplatesExtension < Radiant::Extension
  version "1.3"
  description "Imposes structure on pages via content templates"
  url "http://github.com/seancribbs/radiant-templates-extension/tree/master"

  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :templates, :member => 
                      { :move_higher => :post, :move_lower => :post,
                       :move_to_top => :post, :move_to_bottom => :post}
      admin.resources :part_types, :path_prefix => "/admin/templates"
    end
  end

  def activate
    begin
      FileSystem::MODELS << "PartType" << "Template"
    rescue NameError, LoadError
    end
    Page.class_eval do
      include Templates::Associations
      include Templates::Tags
      include Templates::PageExtensions
    end
    Admin::PagesController.class_eval do
      include Templates::ControllerExtensions 
      helper Templates::Helper
    end
    admin.tabs.add "Templates", "/admin/templates", :before => "Layouts", :visibility => [:developer, :admin]
    # Admin UI customization
    admin.page.edit.add :extended_metadata, 'switch_templates'
    admin.page.edit.add :form, 'edit_template', :before => 'edit_page_parts'
    admin.page.edit.form.delete 'edit_page_parts'
    admin.page.index.add :bottom, 'index_add_child_popup'
    admin.page.index.add :node, 'type_column', :before => 'status_column'
    admin.page.index.add :sitemap_head, 'type_column_header', :before => 'status_column_header'
  end

  def deactivate
    admin.tabs.remove "Templates"
  end
end