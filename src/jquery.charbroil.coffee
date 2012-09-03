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
      @_letter_score = []

      @init()

    init: ->
      # get all <a> links
      @load_links()

      # for all the links we found inside the selector, count characters inside the A
      for link in @links
        text = $(link).html()
        for l in text
          index = l.toLowerCase()
          @_letter_score[index] = 0 if typeof @_letter_score[index] is 'undefined'
          @_letter_score[index]++

      # find data attribute keys
      for link in @links
        # the shortcut letter
        letter = $(link).attr('charbroil-key')
        # no letter then no shortcut =(
        continue if !@is_valid_letter letter
        text = $(link).html()
        @build_char_link(letter, text, link)

      # do first letters
      for link in @links
        continue if @has_charbroil_span link
        text = $(link).html()
        # the shortcut letter
        letter = text[0].toLowerCase()
        # no letter then no shortcut =(
        continue if !@is_valid_letter letter
        # string to pass to keymaster
        @build_char_link(letter, text, link)

      # now we try to be smart
      for link in @links
        continue if @has_charbroil_span link
        # the shortcut letter
        text = $(link).html()
        letter = @find_lowest_score_letter(text.toLowerCase())
        # no letter then no shortcut =(
        continue if !@is_valid_letter letter
        @build_char_link(letter.toLowerCase(), text.toLowerCase(), link)
      this

    is_valid_letter: (letter) ->
      return (letter && @options.exclude.indexOf(letter) is -1)

    has_charbroil_span: (link) ->
      return $(link).find('span.' + @options.hot_key_css_class).length > 0


    build_char_link: (letter, text, link) ->
      # mark it as used
      text = text.toLowerCase()
      @options.exclude.push(letter)
      letter_index = text.indexOf(letter)
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
      # piece together hot letter with rest of word(s)
      $('.' + finder_class_name + ' span').before(before_letter).after(after_letter)
      # bind key using keymaster
      key shortcut, (e, h) ->
        shortcut_class_name = 'charbroil-' + h.shortcut.replace('+', '-')
        window.location = $('.' + shortcut_class_name).attr('href')

    # get all a tags in element
    load_links: ->
      @links = $(@element).find('a')


    find_lowest_score_letter: (word) ->
      for char in word
        if @is_valid_letter(char) 
          if !score || (score && @_letter_score[char] < score)
            letter = char
            score = @_letter_score[char]
      letter

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
