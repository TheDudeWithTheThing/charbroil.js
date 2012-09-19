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
        $el = $(link)
        text = $el.html()
        for l in text
          index = l.toLowerCase()
          @_letter_score[index] = 0 if typeof @_letter_score[index] is 'undefined'
          @_letter_score[index]++

      # find data attribute keys
      for link in @links
        $el = $(link)
        # the shortcut letter from data attribute
        letter = $el.attr('data-charbroil-key')
        text = $el.html()
        if !@is_valid_letter letter
          # or do first letter
          letter = text[0].toLowerCase()
          continue if !@is_valid_letter letter
        @build_char_link(letter, text, $el)

      # now we try to be smart
      for link in @links
        continue if @has_charbroil_span link
        text = $(link).html()
        letter = @find_lowest_score_letter(text.toLowerCase())
        continue if !@is_valid_letter letter
        @build_char_link(letter.toLowerCase(), text.toLowerCase(), link)
      # for chaining
      @element

    # is the letter valid and not used already?
    is_valid_letter: (letter) ->
      return (letter && @options.exclude.indexOf(letter) is -1)

    # contains a hot letter already?
    has_charbroil_span: (link) ->
      return $(link).find('span.' + @options.hot_key_css_class).length > 0

    # builds the link using the element, letter and inner text
    build_char_link: (letter, text, link) ->
      # mark it as used
      @options.exclude.push(letter)
      text = text.toLowerCase()
      shortcut = @build_shortcut_string(letter)
      # class string to be added to the link
      shortcut_class_name = @build_shortcut_class_name shortcut
      # class to use when there are multiple classes for finding <a>
      finder_class_name = @get_finder_class_name shortcut_class_name
      # create span for adding class to letter
      replace_with = '<span class="' + @options.hot_key_css_class + '">' + letter + "</span>"
      $el = $(link)
      # replace letter with span wrapped version of letter
      $el.html( $el.html().replace(letter, replace_with) )
      # add shortcut class to link so we can find this later
      $el.addClass shortcut_class_name
      # bind key using keymaster
      key shortcut, (e, h) ->
        shortcut_class_name = 'charbroil-' + h.shortcut.replace('+', '-')
        window.location = $('.' + shortcut_class_name).attr('href')

    # get all a tags in element
    load_links: ->
      @links = $(@element).find('a')

    # returns the least used letter
    find_lowest_score_letter: (word) ->
      for char in word
        if @is_valid_letter(char) 
          if !score || (score && @_letter_score[char] < score)
            letter = char
            score = @_letter_score[char]
      letter

    build_shortcut_string: (letter) ->
      # accept an array of strings for modifier list
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

    # just gets first class name all the time to use as a reference to element
    get_finder_class_name: (shortcut_classes) ->
      classes = shortcut_classes.split(' ')
      return classes[0]

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  # part of coffeescript jquery boilerplate
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(this, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Charbroil(@, options))
)(jQuery, window)
