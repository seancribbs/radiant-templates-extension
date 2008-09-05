module Templates::Tags
  include Radiant::Taggable
  
  tag 'boolean_part' do |tag|
    tag.expand
  end
  
  tag 'boolean_part:if' do |tag|
    part_name = tag.attr['part']
    raise StandardTags::TagError.new("`boolean_part:if' tag requires a 'part' attribute") unless part_name
    part = tag.locals.page.part(part_name)
    result = part.nil? ? "" : part.content.strip
    tag.expand if result =~ /t|true|1/i
  end
  
  tag 'boolean_part:unless' do |tag|
    part_name = tag.attr['part']
    raise StandardTags::TagError.new("`boolean_part:unless' tag requires a 'part' attribute") unless part_name
    part = tag.locals.page.part(part_name)
    result = part.nil? ? "" : part.content.strip
    tag.expand unless result =~ /t|true|1/i
  end
end
