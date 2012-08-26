#  Project: Charbroil
#  Description: A simple library which looks for all links in the
#               selected element and makes hot keys for them based on the first available letter.
#               Take a char and making it HOT, thus charbroil.
#  Author: Shaun Butler
#  License: MIT

(($, window) ->

  # Create the defaults once
  pluginName = 'charbroil'
  document = window.document
  defaults =
    hot_key_css_class: 'charbroil-hot'
    modifier: 'ctrl'

  # The actual plugin constructor
  class Charbroil
    constructor: (@element, options) ->
      # jQuery has an extend method which merges the contents of two or
      # more objects, storing the result in the first object. The first object
      # is generally empty as we don't want to alter the default options for
      # future instances of the plugin
      @options = $.extend {}, defaults, options

      @_defaults = defaults
      @_name = pluginName
      @_shortcuts = []

      @init()

    init: ->
      # get all <a> links
      @load_links()

      # first pass, addClasses based on available letter
      for link in @links
        text = $(link).html()
        letter_index = @find_available_letter_index text

        # no index then no shortcut =(
        continue if letter_index < 0

        letter = text.charAt(letter_index).toLowerCase()
        @_shortcuts.push letter

        shortcut = @options.modifier + '+' + letter
        shortcut_class_name = 'charbroil-' + shortcut.replace('+', '-')
        # create span for adding class to letter
        before_text = text.substring 0, letter_index
        after_text = text.substring letter_index + 1
        replace_with = $("<span>" + letter + "</span>").addClass(@options.hot_key_css_class)
        $(link).addClass shortcut_class_name
        $(link).html replace_with
        $('.' + shortcut_class_name + ' span').before(before_text).after(after_text)
        key shortcut, (e, h) ->
          shortcut_class_name = 'charbroil-' + h.shortcut.replace('+', '-')
          window.location = $('.' + shortcut_class_name).attr('href')
      this

    load_links: ->
      @links = $(@element).find('a')

    find_available_letter_index: (words) ->
      for index in [0..words.length - 1]
        letter = words[index].toLowerCase()
        # match only a-z
        continue if !/[a-z]/.test letter
        return index if $.inArray(letter, @_shortcuts) == -1 
      return -1

    last_char: (s) ->
      s.charAt(s.length -1)


  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(this, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Charbroil(@, options))
)(jQuery, window)
