# stackoverflow.com/a/4820814/871495
# http://blog.chrisblunt.com/rails-getting-the-id-of-form-fields-inside-a-fields_for-block/

class FormBuilder < ActionView::Helpers::FormBuilder
  def id_for(method, options = {})
    InstanceTag.new(object_name, method, self, object).id_for(options)
  end
end

class InstanceTag < ActionView::Helpers::InstanceTag
  def id_for( options )
    add_default_name_and_id(options)
    options['id']
  end
end

ActionView::Base.default_form_builder = FormBuilder