require 'jquery_popup_uploader'
require 'jquery_popup_uploader/inputs/attachment_preview_input'
require 'jquery_popup_uploader/inputs/image_preview_input'
require 'jquery_popup_uploader/inputs/image_popup_upload_input'
#require 'jquery_popup_uploader/inputs'

module JqueryPopupUploader
  # Your code goes here...
  
  # http://brandonhilkert.com/blog/how-to-build-a-rails-engine/
  # http://stackoverflow.com/questions/23118472/gem-vs-plugin-vs-engine-in-ruby-on-rails
  class Engine < ::Rails::Engine
  end
end

SimpleForm::Inputs.send(:include, JqueryPopupUploader::Inputs)