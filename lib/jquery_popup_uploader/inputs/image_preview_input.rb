module JqueryPopupUploader
  module Inputs
    class ImagePreviewInput < SimpleForm::Inputs::FileInput
      def input(wrapper_options=nil)
        version = input_html_options.delete(:preview_version)
        use_default_url = options.delete(:use_default_url) || false

        out = ''
        if object.send("#{attribute_name}?") || use_default_url
          out << template.image_tag(object.send(attribute_name).tap {|o| break o.send(version) if version}.send('url'))
        end
        (out << super).html_safe # calls method 'input' on superclass
      end
    end
  end
end