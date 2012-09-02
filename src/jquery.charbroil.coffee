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
    exclude: []

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

      @init()

    init: ->
      # get all <a> links
      @load_links()

      # for all the links we found inside the selector
      for link in @links
        text = $(link).html()
        letter_index = @find_available_letter_index text
        # no index then no shortcut =(
        continue if letter_index < 0
        # the shortcut letter
        letter = text.charAt(letter_index).toLowerCase()
        # mark it as used
        @options.exclude.push letter
        # string to pass to keymaster
        shortcut = @build_shortcut_string(letter)
        # class string to be added to the link
        shortcut_class_name = @build_shortcut_class_name shortcut
        # class to use when there are multiple classes for finding <a>
        finder_class_name = @get_finder_class_name shortcut_class_name
        # create span for adding class to letter
        replace_with = $("<span>" + letter + "</span>").addClass(@options.hot_key_css_class)
        # create text for before and after the letter
        before_letter = text.substring 0, letter_index
        after_letter = text.substring letter_index + 1
        # add shortcut class to link so we can find this later
        $(link).addClass shortcut_class_name
        $(link).html replace_with
        $('.' + finder_class_name + ' span').before(before_letter).after(after_letter)
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
        return index if $.inArray(letter, @options.exclude) == -1 
      return -1

    last_char: (s) ->
      s.charAt(s.length -1)

    build_shortcut_string: (letter) ->
      # accept an array of strings
      if @options.modifier instanceof Array
        mods = (mod + '+' + letter for mod in @options.modifier)
        return mods.join ','
      # or a single string
      else
        return @options.modifier + '+' + letter

    build_shortcut_class_name: (keys) ->
      # replace + with - and split by , for sane class names
      classes = ('charbroil-' + s.replace(/\+/g, '-') for s in keys.split /,/)
      return classes.join ' '

    get_finder_class_name: (shortcut_classes) ->
      classes = shortcut_classes.split(' ')
      return classes[0]




  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(this, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Charbroil(@, options))
)(jQuery, window)
