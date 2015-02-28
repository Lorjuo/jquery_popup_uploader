require 'popup_jquery_uploader'
#require 'popup_jquery_uploader/inputs/attachment_preview_input'
#require 'popup_jquery_uploader/inputs/image_preview_input'
require 'popup_jquery_uploader/inputs'

module PopupJqueryUploader
  # Your code goes here...
end

SimpleForm::Inputs::Base.send(:include, PopupJqueryUploader::Inputs)