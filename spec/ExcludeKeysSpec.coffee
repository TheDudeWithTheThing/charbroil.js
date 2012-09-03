describe "Charbroil with exclude option", ->
  beforeEach ->
    loadFixtures 'default-list.html'
    @list = $('.categories').charbroil({modifier: 'shift', exclude: ['a', 'b']})
    @links = $('.categories a')

  # by excluding 'a' we should have a 'p' instead
  # by excluding 'b' bananas will not have a link
  it "should not contain a hot key for the letters in the exclude list", ->
    for link in @links
      expect(link).not.toHaveClass('charbroil-shift-a')
      expect(link).not.toHaveClass('charbroil-shift-b')

    expect($('.charbroil-shift-l')).toBe('a')
