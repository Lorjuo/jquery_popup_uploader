module JqueryPopupUploader::Inputs
  class ImagePopupUploadInput < SimpleForm::Inputs::Base

    def input(wrapper_options=nil)
      #options array gets filled by wrappers: simple_form/wrappers/many.rb



      # HTML options id etc
      merged_html_options = merge_wrapper_options(input_html_options, wrapper_options)
      


      # Plugin specific options
      default_options = {
        :preview_version => :thumb,
        :preview_size => '160x120',
        :use_default_url => false
      }
      input_options = default_options.merge(options) # needs to assign output of merging to a variable that is not called "options"


      image = object.send(attribute_name)
      preview_url = image.send(options[:mount_on]).send(options[:preview_version]).send('url')
      url = image.send(options[:mount_on]).send('url')


      template.content_tag :div, class: 'input-group' do
        @builder.hidden_field(attribute_name, merged_html_options) +
        (template.content_tag :div, class: 'edit-area' do
          (template.link_to(url, :class => 'image fancybox', :caption => object.name) do
            template.image_tag(preview_url, size: options[:preview_size])
          end) +
          (template.content_tag :div, class: 'buttons' do
            template.button_tag('replace', type: 'button', class: "btn btn-primary") +
            template.button_tag('delete', type: 'button', class: "btn btn-primary")
          end)
        end)
      end
    end

  end
end




      # Create dummy input field and scan for id
      # This attempt is compatible with id generation in nested forms,
      # adapts when the underlying code changes,
      # does not need to call any initializer hacks,
      # and does not influence any other code
      # Alternatives:
      # # stackoverflow.com/a/4820814/871495
      # http://blog.chrisblunt.com/rails-getting-the-id-of-form-fields-inside-a-fields_for-block/
    #   dummy_input_field = @builder.hidden_field(attribute_name, merged_html_options)
    #   full_html_id = dummy_input_field.scan(/id="([^"]*)"/).first.first.to_s
      




    #   template.content_tag :div, class: 'input-group' do
        
    #     ac = ActionController::Base.new()
    #     ac.render_to_string :partial => "jquery_popup_uploader/field",
    #       :locals => {
    #         :builder => @builder,
    #         :options => input_options,
    #         :html_options => merged_html_options,
    #         :attribute_name => attribute_name,
    #         :object => object.send(attribute_name),
    #         :full_html_id => full_html_id}
    #   end