// separate a number with commas for thousand-separators
Number.prototype.separators = function separators(){
  var string = this.toString();
  var x      = string.split('.');
  var x1     = x[0];
  var x2     = x.length > 1 ? '.' + x[1] : '';
  var regex  = /(\d+)(\d{3})/;

  while (regex.test(x1)) {
      x1 = x1.replace(regex, '$1' + ',' + '$2');
  }
  return x1 + x2;
};

// pad a number with zeros  
Number.prototype.pad = function pad(length) {
  var str = '' + this;
  while (str.length < length) {
    str = '0' + str;
  }
  return str;
};
