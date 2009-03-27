module Templates::Tags
  include Radiant::Taggable
  
  tag 'boolean_part' do |tag|
    tag.expand
  end
  
  desc %{
    Renders its contents if the selected part contains the text "true".  When
    used with check_box part-types in a template, can turn on and off sections
    of content.  The 'part' attribute is required.
    
    *Usage*:
    
    <pre><code><r:boolean_part:if part="display_sidebar">Sidebar content</r:boolean_part:if></code></pre>
  }
  tag 'boolean_part:if' do |tag|
    part_name = tag.attr['part']
    raise StandardTags::TagError.new("`boolean_part:if' tag requires a 'part' attribute") unless part_name
    part = tag.locals.page.part(part_name)
    # result = part.nil? ? "" : part.content.strip
    result = part.nil? ? "" : (dev?(tag.globals.page.request) && defined?(ConcurrentDraftExtension) ? part.draft_content.strip : part.content.strip)
    tag.expand if result =~ /t|true|1/i
  end
  
  desc %{
    Renders its contents if the selected part does not contain the text "true".  When
    used with check_box part-types in a template, can turn on and off sections
    of content.  The 'part' attribute is required.
    
    *Usage*:
    
    <pre><code><r:boolean_part:unless part="display_sidebar">Sidebar content</r:boolean_part:unless></code></pre>
  }
  tag 'boolean_part:unless' do |tag|
    part_name = tag.attr['part']
    raise StandardTags::TagError.new("`boolean_part:unless' tag requires a 'part' attribute") unless part_name
    part = tag.locals.page.part(part_name)
    # result = part.nil? ? "" : part.content.strip
    result = part.nil? ? "" : (dev?(tag.globals.page.request) && defined?(ConcurrentDraftExtension) ? part.draft_content.strip : part.content.strip)
    tag.expand unless result =~ /t|true|1/i
  end
end
