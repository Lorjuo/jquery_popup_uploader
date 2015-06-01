# JqueryPopupUploader

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'jquery_popup_uploader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jquery_popup_uploader

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jquery_popup_uploader/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## CUSTOM
Steps to use this plugin

Create Uploader with cropped version

Add jquery_popup_uploader to form
Add Utilities on top of form

Enable <image>_id in permitted_attributes
create empty <image> object in edit and new actions
exclude <image>_id in new and update methods
use update_image_associations from ImageAssociationsHelper in update and create method