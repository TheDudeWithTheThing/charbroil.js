describe "Charbroil Data Attribute", ->
  beforeEach ->
    loadFixtures 'data-attribute-list.html'
    @list = $('.categories').charbroil()
    @links = $('.categories a')

  it "should link based on the data attribute letter", ->
    for link in @links
      letter = $(link).attr('charbroil-key')
      expect(link).toHaveClass('charbroil-ctrl-' + letter) if letter
