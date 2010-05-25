module Templates::Helper

  def gt8; Radiant::Version.to_s >= "0.8" end 
  
  def page_part_name(index)
    gt8 ? "page[parts_attributes][#{index}]" : "page[parts][]" 
  end
  
  def template_part_field(template_part, index, drafts_enabled = false)
    field_html = []
    if drafts_enabled
      live_part_content = gt8 ? @page.part(template_part.name).try(:content) || '' : @page.part(template_part.name).content rescue ''
      live_field_name = "#{page_part_name(index)}[content]"
      live_field_id = "page_parts_#{index}_content"
      # part_content = @page.part(template_part.name).try(:draft_content) || ''
      part_content = gt8 ? @page.part(template_part.name).try(:draft_content) || '' : @page.part(template_part.name).draft_content rescue ''
      field_name = "#{page_part_name(index)}[draft_content]"
      field_id = "page_parts_#{index}_draft_content"
      field_html << hidden_field_tag(live_field_name, h(live_part_content), :id => live_field_id)
    else
      part_content = gt8 ? @page.part(template_part.name).try(:content) || '' : @page.part(template_part.name).content rescue ''
      field_name = "#{page_part_name(index)}[content]"
      field_id = "page_parts_#{index}_content"
    end

    options = {:class => template_part.part_type.field_class, 
               :style => template_part.part_type.field_styles,
               :id => field_id}.reject{ |k,v| v.blank? }

    case template_part.part_type.field_type
      when "text_area"
        field_html << text_area_tag(field_name, h(part_content), options)

      when "text_field"
        field_html << text_field_tag(field_name, h(part_content), options)

      when "radio_button"
        options[:id] = "#{field_id}_true"
        field_html << " &mdash; " + radio_button_tag(field_name, "true", part_content =~ /true/, options) + label_tag("True")
        options[:id] = "#{field_id}_false"
        field_html << radio_button_tag(field_name, "false", part_content !~ /true/, options) + label_tag("False")

      when "hidden"
        field_html << hidden_field_tag(field_name, part_content, options)

      when "predefined"
        field_html << hidden_field_tag(field_name, template_part.description, options)
    end

    field_html.join("\n")
  end

end