module PopupJqueryUploader::Inputs
  class ImagePopupUploadInput < SimpleForm::Inputs::FileInput

    def input(wrapper_options=nil)
      version = input_html_options.delete(:preview_version)
      use_default_url = options.delete(:use_default_url) || false

      template.content_tag :div, class: 'input-group' do
        #input = super(wrapper_options) # call superclass method (for rendering real file input field?)
        
        ac = ActionController::Base.new()
        ac.render_to_string :partial => "popup_jquery_uploader/field",
          :locals => {
            :object => object,
            :attribute_name => attribute_name,
            :version => version,
            :use_default_url => use_default_url}
      end
    end

  end
end