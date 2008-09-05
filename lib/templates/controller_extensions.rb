module Templates::ControllerExtensions
  def self.included(base)
    base.class_eval {
      before_filter :load_template, :only => [:new, :edit]
    }
  end
  
  def load_template
    unless params[:template].blank?
      case params[:template].to_i
        when 0
          @content_template = ''
          params[:page][:template_id] = nil if params[:page]
        else
          @content_template = Template.find(params[:template])
          params[:page][:template_id] = @content_template.id if params[:page]
      end
    end
  end
end
