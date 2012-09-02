// Generated by CoffeeScript 1.3.3

describe("Charbroil with exclude option", function() {
  beforeEach(function() {
    loadFixtures('default-list.html');
    this.list = $('.categories').charbroil({
      modifier: 'shift',
      exclude: ['a', 'b']
    });
    return this.links = $('.categories a');
  });
  return it("should not contain a hot key for the letters in the exclude list", function() {
    var link, _i, _len, _ref;
    _ref = this.links;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      link = _ref[_i];
      expect(link).not.toHaveClass('charbroil-shift-a');
      expect(link).not.toHaveClass('charbroil-shift-b');
    }
    expect($('.charbroil-shift-p')).toBe('a');
    return expect($('.charbroil-shift-n')).toBe('a');
  });
});
