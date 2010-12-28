module Grundlebox
  module Forms
    class LabelledFormBuilder < ActionView::Helpers::FormBuilder
      LABELED_OPTIONS = [:label, :wrap, :wrap_class, :label_position, :note, :required, :for]
  
      private
      def self.create_tagged_field(method_name, label = true)
        define_method(method_name) do |method, *args|
          options = args.extract_options!
          labeled_options = extract_labeled_options(options)
          labeled_options[:label_position] ||= :wrap if [:check_box, :radio_button].include?(method_name)
          options[:class] = "#{options[:class]} required".strip if labeled_options[:required]
          options[:class] = [method_name, options[:class]].compact.join(" ")
          args << options
      
          field = super(method, *args)
          field = labeled_field(method, field, labeled_options) if label
          field += add_note(labeled_options[:note]) unless labeled_options[:note].blank?
          tagged_field(field, labeled_options[:wrap], labeled_options[:wrap_class])
        end
      end
  
      public
      %w(text_field password_field file_field text_area check_box radio_button select collection_select date_select datetime_select time_select).each do |name|
        create_tagged_field(name.to_sym)
      end
  
      %w(submit).each do |name|
        create_tagged_field(name.to_sym, false)
      end
    
      def tag_select(method, options = {})
        labeled_field(method, ActionView::Helpers::InstanceTag.new(@object_name, method, self, options[:object] || @object).to_tag).html_safe
      end
      
      def input(method, options = {})
        labeled_field(method, ActionView::Helpers::InstanceTag.new(@object_name, method, self, options[:object] || @object).to_tag).html_safe
      end
  
      protected
  
      def tagged_field(field, tag = false, css_class = nil)
        tag.blank? ? field : content_tag(tag, field, :class => css_class)
      end
  
      def labeled_field(method, field, options = {})
        return field if options[:label] == false
        method, lbl = method.to_s, options[:label]
        klass, msg = nil
    
        if object.nil?
          lbl ||= "#{method.humanize}"
          msg = lbl
        else
          errors  = object.errors[method]
          lbl ||= object.class.human_attribute_name method
          msg     = lbl
          unless errors.blank?
            klass = 'error'
            msg  += ' ' + ((errors.class == Array) ? errors.join(' and ') : errors)
          end
        end
    
        if options[:required]
          lbl +="<span class=\"required\">*</span>".html_safe
          klass = "#{klass} required".strip
        end
    
        if options[:label_position] == :wrap
          fields = [label(method, "#{field} #{lbl}".html_safe, objectify_options({:class => "#{klass} #{options[:wrap_class] || 'wrap_label'}", :title => msg, :for => options[:for]})).html_safe]
        else
          fields = [label(method, lbl.html_safe, objectify_options({:class => klass, :title => msg, :for => options[:for]})).html_safe, field.html_safe]
          fields.reverse! if options[:label_position] == :after
        end
    
        fields.join("").html_safe
      end
  
      def add_note(note)
        %(<span class="form_note">#{note}</span>).html_safe
      end
  
      def extract_labeled_options(options)
        o = {}
        LABELED_OPTIONS.each do |k|
          o[k] = options.delete k
        end
        o
      end
    end
  end
end