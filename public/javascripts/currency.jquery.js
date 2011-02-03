// A currency object which takes a floating-point value and turns it into a WoW currency value in gold, silver and copper
jQuery(document).ready(function() {
  Currency = function(value){
    this.gold   = 0;
    this.silver = 0;
    this.copper = 0;
    this.initialize(value);
  };
  
  Currency.prototype.initialize = function(value){
    var currency = this;
    value = parseFloat(value, 10);
    
		currency.gold   = Math.floor(value);
		currency.silver = Math.floor((value - currency.gold) * 100);
		currency.copper = Math.round((((value - currency.gold) * 100) - currency.silver) * 100);
  };
  
  Currency.prototype.tags = function(){
    var currency = this;
    var coins    = ['gold', 'silver', 'copper'];
    var wrapper  = jQuery('<div class="wrapper">');

    jQuery.each(coins, function(i, coin){
      var tag = jQuery('<var>').addClass(coin).text(currency[coin]);
      if (currency[coin] != 0 || wrapper.contents().length > 0) {
        wrapper.append(tag);
      }
    });
		
		return wrapper.contents();
  };
  
});
