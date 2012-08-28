# the simplest test I could possibly write for this thing
describe "Charbroil Simple Defaults", -> 
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
      expect($(link).find('span')).toHaveClass('charbroil-hot')

  it "should contain the full word in the link", ->
    for link in @links
      $(link).find('span').remove()
      expect($(link).html().length).toBeGreaterThan(0)

