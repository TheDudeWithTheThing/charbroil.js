describe "Charbroil", ->

  describe "with defaults", ->
    beforeEach ->
      loadFixtures 'default-list.html'
      @list = $('.categories').charbroil()
      @links = $('.categories a')

    it "should add shortcut classes to links with matching hot key", ->
      for link in @links
        letter = $(link).find('span').html().charAt(0).toLowerCase()
        expect(link).toHaveClass('charbroil-ctrl-' + letter)

    it "should have a highlighted letter", ->
      for link in @links
        expect($(link).find('span.charbroil-hot').length).toBeGreaterThan(0)

    it "should contain the full word in the link", ->
      for link in @links
        $(link).find('span').remove()
        expect($(link).html().length).toBeGreaterThan(0)

  describe "with multiple modifiers", ->
    beforeEach ->
      loadFixtures 'default-list.html'
      @list = $('.categories').charbroil({modifier: ['command','shift']})
      @links = $('.categories a')

    it "should add shortcut class for command and shift with matching hot key", ->
      for link in @links
        letter = $(link).find('span').html().charAt(0)
        expect($(link)).toHaveClass('charbroil-shift-' + letter)
        expect($(link)).toHaveClass('charbroil-command-' + letter)

  describe "with charbroil-key data attribute", ->
    beforeEach ->
      loadFixtures 'data-attribute-list.html'
      @list = $('.categories').charbroil()
      @links = $('.categories a')

    it "should make shortcut key based on the charbroil-key letter", ->
      for link in @links
        letter = $(link).attr('charbroil-key')
        expect($(link)).toHaveClass('charbroil-ctrl-' + letter) if letter

  describe "with exclude option", ->
    beforeEach ->
      loadFixtures 'default-list.html'
      @list = $('.categories').charbroil({modifier: 'shift', exclude: ['a', 'b']})
      @links = $('.categories a')

    # by excluding 'a' we should have a 'l' instead
    # by excluding 'b' bananas will not have a link
    it "should not contain a hot key for the letters in the exclude list", ->
      for link in @links
        expect(link).not.toHaveClass('charbroil-shift-a')
        expect(link).not.toHaveClass('charbroil-shift-b')
      expect($('.charbroil-shift-l')).toBe('a')

