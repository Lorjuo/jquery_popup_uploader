# https://github.com/jquery-boilerplate/jquery-boilerplate/blob/master/src/jquery.boilerplate.coffee

# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "jquery_popup_uploader"
  defaults =
    property: "value"

  # The actual plugin constructor
  class Plugin
    constructor: (@element, options) ->
      # jQuery has an extend method which merges the contents of two or
      # more objects, storing the result in the first object. The first object
      # is generally empty as we don't want to alter the default options for
      # future instances of the plugin
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      #@element is modal
      @input_wrappers = $('.jpu-input-wrapper')
      @init()
      @current_wrapper

    init: ->
      # Place initialization logic here
      # You already have access to the DOM element and the options via the instance,
      # e.g., @element and @settings
      @initCallbacks()
      @initFileupload()
      console.log "[image_popup_upload] plugin loaded"
    
    initCallbacks: ->
      plugin = this

      # Replace
      $(@input_wrappers).find('.jpu-replace').on "click", (event) ->
        console.log("replace button clicked")
        plugin.openModal()
        plugin.current_wrapper = event.target.closest('.jpu-input-wrapper')
        target_url = $(plugin.current_wrapper).find('input').data('target-url')
        $(plugin.element).find('form').attr('action', target_url)

      # Delete
      $(@input_wrappers).find('.jpu-delete').on "click", (event) ->
        preview_image = $(plugin.current_wrapper).find('input').data('default-preview-image')
        full_image = $(plugin.current_wrapper).find('input').data('default-full-image')

        # set preview image
        $(plugin.current_wrapper).find('div.edit-area img').attr('src', preview_image)
        $(plugin.current_wrapper).find('div.edit-area a').attr('href', full_image)

        # set new image id
        $(plugin.current_wrapper).find('input.image_popup_upload').val(0)

    initFileupload: ->
      $('.jpu-fileupload').fileupload

        # Automatically start upload when files have been selected
        autoUpload: true

        # Use ajax via javascript instead of json return
        dataType: "script"

        # Disable Iframe transport because this is only a hack for IE < version 10 that doesn't support XmlHttpRequests
        # IframeTransport will be automatically used if normal way fails
        forceIframeTransport: false

        # This settings seem to have no effect at the moment, because they get overridden by processQueue
        #loadImageMaxFileSize: 25000000 # 25MB
        #imageMaxWidth: 1920
        #imageMaxHeight: 1920
        #disableImageResize: false
        #disableImageMetaDataLoad: false
        #imageOrientation: true
        #imageCrop: true

        # BEST SOURCE:
        # https://github.com/blueimp/jQuery-File-Upload/wiki/Options#file-processing-options
        # see also the following file for the processing actions: jquery.fileupload-image.js
        #https://github.com/tors/jquery-fileupload-rails/blob/master/app/assets/javascripts/jquery-fileupload/jquery.fileupload-image.js
        processQueue: [
          {
            action: 'loadImageMetaData'
            # disableImageHead: '@',
            # disableExif: '@',
            # disableExifThumbnail: '@',
            # disableExifSub: '@',
            # disableExifGps: '@',
            # disabled: '@disableImageMetaDataLoad'
          },
          {
            action : 'loadImage',
            fileTypes : /^image\/(gif|jpeg|png)$/,
            maxFileSize: 25000000 # 25MB
          }, {
            action : 'resizeImage',
            maxWidth: 1920,
            maxHeight: 1920,
            #crop : true
            orientation: true
          }, {
            action : 'saveImage',
            type : 'image/jpeg',
            quality : 1 #A Number between 0 and 1 indicating image quality
          }
          #{
          #  action : "setImage"
          #}
        ]

        add: (e, data) ->
          if (data.files && data.files[0])
            file = data.files[0]
            if(file.size < 25000000)
              if(file.type.substr(0, file.type.indexOf('/')) != 'image')
                alert("Please upload a file with the correct format")
              else
                #$(@element).find("#template_area").hide 'puff', {}, 1000, ->
                #  $(@element).find("#template_area").html('')

                current_data = $(this)
                data.process(->
                  return current_data.fileupload('process', data); #call the process function
                ).done(->
                  data.context = $($.parseHTML(tmpl("template-upload", file)))
                  $('.jpu-fileupload').append(data.context)
                  xhr = data.submit();
                  data.context.data('data',{jqXHR: xhr});
                )
            else
              alert("one of your files is over 25MB")
        
        progress: (e, data) ->
          if data.context
            progress = parseInt(data.loaded / data.total * 100, 10)
            data.context.find('.progress-bar').css('width', progress + '%')
        
        done: (e, data) ->
          data.context.find('.progress-bar').addClass('progress-bar-success')
          data.context.find('.progress').removeClass('progress-striped active')

        always: (e, data) ->
          data.context.find('.progress').removeClass('progress-striped active')
          data.context.find('.progress-bar').css('width', 100 + '%')
          setTimeout (->
            data.context.hide() # hide progress bar
          ), 3000
        
        fail: (e, data) ->
          data.context.find('.progress-bar').addClass('progress-bar-danger')
          alert("#{data.files[0].name} failed to upload.")
          console.log("Upload failed:")
          console.log(data)

    openModal: ->
      console.log "[image_popup_upload] openModal()"
      plugin = this
      $(@element).find("input").val('')
      $(@element).find("#template_area").html('')
      $(@element).modal('show')
      # ensure that callback is only fired once:
      # http://stackoverflow.com/questions/14969960/jquery-click-events-firing-multiple-times
      $(@element).find("button.apply").off().bind 'click', ->
        plugin.applyChanges()

    applyChanges: ->
      console.log "[image_popup_upload] applyChanges()"
      plugin = this
      imageId = $(@element).find('.image-info').data('image-id')
      if !imageId
        return false
      
      # Get Attributes
      crop_x = $(@element).find('input.crop_x').val()
      crop_y = $(@element).find('input.crop_y').val()
      crop_w = $(@element).find('input.crop_w').val()
      crop_h = $(@element).find('input.crop_h').val()
      crop_url = $(@element).find("#template_area").data('crop-url')
      preview_version = $(@current_wrapper).find('input').data('preview-version')

      $('body').addClass("loading");
      $.ajax(
        url: crop_url
        data:
          'image[file_crop_x]': crop_x
          'image[file_crop_y]': crop_y
          'image[file_crop_w]': crop_w
          'image[file_crop_h]': crop_h
          'preview_version': preview_version
      ).success((data) ->
        console.log 'cropping succeeded'

        # set preview image
        $(plugin.current_wrapper).find('div.edit-area img').attr('src', data.preview_image)
        $(plugin.current_wrapper).find('div.edit-area a').attr('href', data.full_image)

        # set new image id
        $(plugin.current_wrapper).find('input.image_popup_upload').val(imageId)

        #close modal
        $(plugin.element).modal('hide')

      ).error((data) ->
        console.log 'cropping failed'
      ).done ->
        $('body').removeClass("loading");

      #TODO: Problem: executed multiple times -> Check
      #APPLY Preview image
      #CROPPING
      #ADJUST BUTTONS edit/replace

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new Plugin @, options

$ ->
  $("#jpu-modal").jquery_popup_uploader {} # seems to work only on one element
  #new Plugin( $("div.form-group.image_popup_upload"), {} );
  #myplugin = $.jquery_popup_uploader($('div.form-group.image_popup_upload'))