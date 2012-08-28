describe "Charbroil with multiple modifiers", ->
  beforeEach ->
    loadFixtures 'default-list.html'
    @list = $('.categories').charbroil({modifier: ['command','shift']})
    @links = $('.categories a')

  it "should add shortcut class for command and shift with matching hot key", ->
    for link in @links
      letter = $(link).find('span').html().charAt(0).toLowerCase()
      expect(link).toHaveClass('charbroil-shift-' + letter)
      expect(link).toHaveClass('charbroil-command-' + letter)

