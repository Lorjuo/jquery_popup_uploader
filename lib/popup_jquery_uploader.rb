require 'popup_jquery_uploader'
require 'popup_jquery_uploader/inputs/attachment_preview_input'
require 'popup_jquery_uploader/inputs/image_preview_input'
require 'popup_jquery_uploader/inputs/image_popup_upload_input'
#require 'popup_jquery_uploader/inputs'

module PopupJqueryUploader
  # Your code goes here...
  
  # http://brandonhilkert.com/blog/how-to-build-a-rails-engine/
  # http://stackoverflow.com/questions/23118472/gem-vs-plugin-vs-engine-in-ruby-on-rails
  class Engine < ::Rails::Engine
  end
end

SimpleForm::Inputs.send(:include, PopupJqueryUploader::Inputs)