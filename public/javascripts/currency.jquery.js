// A currency object which takes a floating-point value and turns it into a WoW currency value in gold, silver and copper
jQuery(document).ready(function() {
  Currency = function(value){
    this.intValue = 0;
    this.gold     = 0;
    this.silver   = 0;
    this.copper   = 0;
    this.initialize(value);
  };
  
  Currency.prototype.initialize = function(value){
    var currency      = this;
        
        
    var currencyFromInt = function(currency, value) {
      currency.intValue = parseInt(value, 10);
      var valueString   = currency.intValue.toString();

  		currency.gold   = parseInt(valueString.substr(0, valueString.length-4),10);
  		currency.silver = parseInt(valueString.substr(valueString.length-4, 2),10);
  		currency.copper = parseInt(valueString.substr(valueString.length-2, 2),10);
    };
        
    switch (typeof value) {
      case "number":
        // number in format 1234567 => 123g 45s 67c
        currencyFromInt(currency, value);
        break;
      case "string":
        var reNumberString     = /^\d+$/;
        var reGoldSilverCopper = /^(\d+\s*g|\d{1,3}[,(?=\d{3})]+\s*g)?\s*(\d{1,2}\s*s)?\s*(\d{1,2}\s*c)?$/;
        
        if (value.match(reNumberString)) {
          // string in format 12434567 => 123g 45s 67c
          currencyFromInt(currency, value);
        } else {
          // string in format 123g 45s 67c
          var components = value.match(reGoldSilverCopper);
          var str_gold   = "";
          var str_silver = "";
          var str_copper = "";

          if (components) {
            if (components[1] != null) {
              currency.gold = parseInt(components[1].replace(',','').replace('g',''),10);
              str_gold      = currency.gold.toString();
            }
            if (components[2] != null) {
              currency.silver = parseInt(components[2].replace('s',''),10);
              str_silver      = currency.silver.pad(2);
            } else str_silver = "00";
            if (components[3] != null) {
              currency.copper = parseInt(components[3].replace('c',''),10);
              str_copper      = currency.copper.pad(2);
            } else str_copper = "00";
            currency.intValue = parseInt(str_gold + str_silver + str_copper, 10);
          }
        }
        break;
    }
  };
  
  Currency.prototype.toHTML = function(){
    var currency = this;
    var coins    = ['gold', 'silver', 'copper'];
    var wrapper  = jQuery('<div class="wrapper">');

    jQuery.each(coins, function(i, coin){
      if (currency[coin] != 0 || wrapper.contents().length > 0) {
        wrapper.append(jQuery('<var>').addClass(coin).text(currency[coin].separators()));
      }
    });
		
		return wrapper.contents();
  };
  
  Currency.prototype.toString = function(){
    var currency = this;
    var coins    = ['gold', 'silver', 'copper'];
    var output   = "";
    
    jQuery.each(coins, function(i, coin){
      if (currency[coin] != 0 || output.length > 0) {
        output += currency[coin].separators() + coin.substr(0,1) + ' ';
      }
    });
		
		return jQuery.trim(output);
  };
  
  Currency.prototype.toNumber = function(){
    return this.intValue;
  };
  
});
