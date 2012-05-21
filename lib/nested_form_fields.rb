require "nested_form_fields/version"

module NestedFormFields
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end

module ActionView::Helpers

  class FormBuilder

    def nested_fields_for(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_options[:builder] ||= options[:builder]
      fields_options[:parent_builder] = self
      fields_options[:namespace] = fields_options[:parent_builder].options[:namespace]

      return fields_for_with_nested_attributes_with_template(record_name, record_object, fields_options, block)
    end


    def add_nested_fields_link association, text = nil
      @template.link_to text || "Add #{association.to_s.singularize.humanize}", '',
                        class: "add_nested_fields_link",
                        data: { association_path: association_path(association.to_s) }
    end

    def remove_nested_fields_link text = nil
      @template.link_to text || 'x', '',
                        class: "remove_nested_fields_link",
                        data: { delete_association_field_name: delete_association_field_name }
    end


    private

    def fields_for_with_nested_attributes_with_template(association_name, association, options, block)
      name = "#{object_name}[#{association_name}_attributes]"
      association = convert_to_model(association)

      if association.respond_to?(:persisted?)
        association = [association] if @object.send(association_name).is_a?(Array)
      elsif !association.respond_to?(:to_ary)
        association = @object.send(association_name)
      end

      if association.respond_to?(:to_ary)
        explicit_child_index = options[:child_index]
        output = ActiveSupport::SafeBuffer.new
        association.each do |child|
          output << nested_fields_wrapper(association_name) do
            fields_for_nested_model("#{name}[#{explicit_child_index || nested_child_index(name)}]", child, options, block)
          end
        end

        templates = nested_model_template(name, association_name, options, block)
        output << templates

        output
      elsif association
        fields_for_nested_model(name, association, options, block)
      end
    end


    def nested_model_template name, association_name, options, block
      for_template = self.options[:for_template]

      # Render the outermost template in a script tag to avoid it from being submited with the form
      # Render all deeper nested templates as hidden divs as nesting script tags messes up the html.
      # When nested fields are added with javascript by using a template that contains nested templates,
      # the outermost nested templates div's are replaced by script tags to prevent those nested templates
      # fields from form subission.
      #
      @template.content_tag( for_template ? :div : :script,
                             type: for_template ? nil : 'text/html',
                             id: template_id(association_name),
                             class: for_template ? 'form_template' : nil,
                             style: for_template ? 'display:none' : nil ) do
        nested_fields_wrapper(association_name) do
          fields_for_nested_model("#{name}[#{index_placeholder(association_name)}]",
                                   association_name.to_s.classify.constantize.new,
                                   options.merge(for_template: true), block)
        end
      end
    end


    def template_id association_name
      "#{association_path(association_name)}_template"
    end

    def association_path association_name
      "#{object_name.gsub('][','_').gsub(/_attributes/,'').sub('[','_').sub(']','')}_#{association_name}"
    end

    def index_placeholder association_name
      "__#{association_path(association_name)}_index__"
    end

    def delete_association_field_name
      "#{object_name}[_destroy]"
    end


    def nested_fields_wrapper association_name
      @template.content_tag :fieldset, class: "nested_fields nested_#{association_path(association_name)}" do
        yield
      end
    end

  end

end
