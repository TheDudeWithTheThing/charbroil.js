describe "Charbroil with exclude option", ->
  beforeEach ->
    loadFixtures 'default-list.html'
    @list = $('.categories').charbroil({modifier: 'shift', exclude: ['a', 'b']})
    @links = $('.categories a')

  # by excluding 'a' we should have a 'p' instead
  # by excluding 'b' we should have a 'n' instead
  it "should not contain a hot key for the letters in the exclude list", ->
    for link in @links
      expect(link).not.toHaveClass('charbroil-shift-a')
      expect(link).not.toHaveClass('charbroil-shift-b')

    expect($('.charbroil-shift-p')).toBe('a')
    expect($('.charbroil-shift-n')).toBe('a')
