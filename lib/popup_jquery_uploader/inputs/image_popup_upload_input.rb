module PopupJqueryUploader::Inputs
  class ImagePopupUploadInput < SimpleForm::Inputs::Base

    def input(wrapper_options=nil)
      #options array gets filled by wrappers: simple_form/wrappers/many.rb

      # HTML options id etc
      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
      


      # Plugin specific options
      default_options = {
        :preview_version => :thumb,
        :preview_size => '160x120',
        :use_default_url => false
      }
      opts = default_options.merge(options) # needs to assign output of merging to a variable that is not called "options"

      template.content_tag :div, class: 'input-group' do
        #debugger
        input = @builder.hidden_field(attribute_name, merged_input_options)
        
        ac = ActionController::Base.new()
        input += ac.render_to_string :partial => "popup_jquery_uploader/field",
          :locals => {
            :object => object.send(attribute_name),
            :options => opts}

        input
      end
    end

  end
end