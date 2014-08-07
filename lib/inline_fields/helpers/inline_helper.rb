module InlineHelper
  def fields_for_child(klass, association, child)
    new_parent = klass.new
    id = child.object_id

    fields = ''
    simple_form_for new_parent do |f|
      fields = f.fields_for(association, child, child_index: id) do |builder|
        render("#{association.to_s}/#{association.to_s.singularize}_inline_fields", f: builder)
      end
      fields += f.input :id, as: :hidden unless child.new_record?
    end

    fields
  end
end