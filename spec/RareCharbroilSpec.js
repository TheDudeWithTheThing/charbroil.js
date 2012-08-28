// Generated by CoffeeScript 1.3.3

describe("Charbroil Simple Defaults", function() {
  beforeEach(function() {
    loadFixtures('default-list.html');
    this.list = $('.categories').charbroil();
    return this.links = $('.categories a');
  });
  it("should add shortcut classes to links with matching hot key", function() {
    var letter, link, _i, _len, _ref, _results;
    _ref = this.links;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      link = _ref[_i];
      letter = $(link).find('span').html().charAt(0).toLowerCase();
      _results.push(expect(link).toHaveClass('charbroil-ctrl-' + letter));
    }
    return _results;
  });
  it("should have a highlighted letter", function() {
    var link, _i, _len, _ref, _results;
    _ref = this.links;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      link = _ref[_i];
      _results.push(expect($(link).find('span')).toHaveClass('charbroil-hot'));
    }
    return _results;
  });
  return it("should contain the full word in the link", function() {
    var link, _i, _len, _ref, _results;
    _ref = this.links;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      link = _ref[_i];
      $(link).find('span').remove();
      _results.push(expect($(link).html().length).toBeGreaterThan(0));
    }
    return _results;
  });
});
