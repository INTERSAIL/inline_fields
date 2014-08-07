module ActionView
  module Helpers
    class FormBuilder
      def inline_fields_for(association, options = {})
        name_link_to_add = options.is_a?(String) ? options : options.delete(:add_link_name)
        res = options.key?(:headers) ? self.inline_headers(association, options.delete(:headers)) : ''

        res += self.fields_for association.to_sym do |row|
          template.render("#{association.to_s}/#{association.to_s.singularize}_inline_fields", f: row )
        end
        if name_link_to_add
          res += link_to_add_inline_fields(name_link_to_add, association)
        end
        res
      end

      def link_to_add_inline_fields(name, association)
        new_object = self.object.send(association).klass.new
        id = new_object.object_id
        fields = self.fields_for(association, new_object, child_index: id) do |builder|
          template.render("#{association.to_s}/#{association.to_s.singularize}_inline_fields", f: builder)
        end
        template.link_to(name, '#', class: 'add_fields', data: {id: id, fields: fields.gsub("\n", '')})
      end

      def inline_headers(association, titles, options={})
        template.content_tag(:div, class:"row row-header #{html_class(options)}") do
          titles.each do |title, opts|
            k = opts.to_s

            if title.to_s == '_actions'
              template.concat template.content_tag(:div, template.raw('&nbsp'), class: k)
            else
              template.concat template.content_tag(:div, template.t("activerecord.attributes.#{association.to_s.singularize}.#{title}", default: title.to_s.titleize), class: k)
            end
          end
        end
      end

      def inline_input(name, options = {})
        options[:input_html] ||= {}
        options[:input_html][:data] ||= {}

        options[:input_html][:data].reverse_merge!(name: "#{self.object.class.to_s.underscore}[#{name}]")

        options.reverse_merge!(label: false, placeholder: template.t("activerecord.attributes.#{self.object.class.to_s.underscore}.#{name}", default: name.to_s))

        self.input name, options
      end

      def inline_div_id
        @inline_div_id ||= "container_#{self.object.object_id}"
      end

      def inline_div(options = {})
        template.content_tag(:div, id: inline_div_id, class: "form-inline inline-row row #{html_class(options)}") do
          yield
        end
      end

      def inline_row_data(options = {})
        res = template.content_tag(:div, class: "row-data #{html_class(options)}") do
          yield
        end
        unless self.object.new_record?
          res += self.inline_input :id, as: :hidden, input_html: { data:{name: 'id'} }
        end
        res
      end

      def inline_row_actions(options = {})
        template.content_tag(:div, class: "row-actions #{html_class(options)}") do
          template.concat self.input :_destroy, as: :hidden, input_html: { data: {destroy_field: 1} }
          yield
        end
      end

      def inline_button_remove(name)
        template.content_tag(:button, name, type:'button', class: 'row-remove', data: {target: inline_div_id})
      end

      def inline_button_edit(name)
        template.content_tag(:button, name, type: 'button', class: 'row-edit', data: { target: inline_div_id, edit_url: template.send("form_for_#{self.object.class.to_s.underscore.pluralize}_path") })
      end

      private
      def html_class(options, default='')
        (options.delete(:class) || options[:input_html] && options[:input_html].delete(:class)) || default
      end
    end
  end
end

