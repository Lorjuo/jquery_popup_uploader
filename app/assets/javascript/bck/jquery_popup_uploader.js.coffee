# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "popup_uploader"
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
      @init()

    init: ->
      # Place initialization logic here
      # You already have access to the DOM element and the options via the instance,
      # e.g., @element and @settings
      @initCallbacks()
      @initFileupload()
      console.log "[image_popup_upload] plugin loaded"
    
    initCallbacks: ->
      plugin = this
      $(@element).find('.jpu-replace').on "click", ->
        console.log("replace button clicked")
        plugin.openModal()

    initFileupload: ->
      $(@element).find('.jpu-fileupload').fileupload

        # Automatically start upload when files have been selected
        autoUpload: true

        # Use ajax via javascript instead of json return
        dataType: "script"

        # Disable Iframe transport because this is only a hack for IE < version 10 that doesn't support XmlHttpRequests
        # IframeTransport will be automatically used if normal way fails
        forceIframeTransport: false

        # Processing image on client side
        loadImageMaxFileSize: 25000000 # 25MB
        imageMaxWidth: 800
        imageMaxHeight: 800
        disableImageResize: false
        process:[
          {
            action: 'load',
            fileTypes: /^image\/(gif|jpeg|png)$/,
            maxFileSize: 25000000 # 25MB
          },
          {
            action: 'resize',
            maxWidth: 800,
            maxHeight: 800#,
            #minWidth: 480,
            #minHeight: 360
          },
          {
            action: 'save'
          }
        ]

        add: (e, data) ->
          if (data.files && data.files[0])
            file = data.files[0]
            if(file.size < 25000000)
              if(file.type.substr(0, file.type.indexOf('/')) != 'image')
                alert("Please upload a file with the correct format")
              else
                current_data = $(this)
                data.process(->
                  return current_data.fileupload('process', data); #call the process function
                ).done(->
                  data.context = $($.parseHTML(tmpl("template-upload-popup", file)))
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
          setTimeout (->
            data.context.hide()
          ), 3000

        always: (e, data) ->
          data.context.find('.progress').removeClass('progress-striped active')
          data.context.find('.progress-bar').css('width', 100 + '%')
        
        fail: (e, data) ->
          data.context.find('.progress-bar').addClass('progress-bar-danger')
          alert("#{data.files[0].name} failed to upload.")
          console.log("Upload failed:")
          console.log(data)

    openModal: ->
      $(@element).find('.modal').modal()

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new Plugin @, options

$ ->
  $("div.form-group.image_popup_upload").popup_uploader {}