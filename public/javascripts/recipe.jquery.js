// update a dl.recipe with input elements and bind all methods to update its value accordingly
$(document).ready(function() {
  
  jQuery.fn.recipe = function(){
    var recipe = this;
    
    jQuery(recipe).children('dd').each(function(){
      var itemLink = $(this).children('a');
      if (jQuery(this).children('input').length == 0) {
        var priceInput = jQuery('<input type="text" class="price">');
        priceInput.attr('value', itemLink.attr('data-item-price'));
        priceInput.attr('id', 'item_' + itemLink.attr('data-item-id'));
        
        // select the contents of inputs when focused
        priceInput.bind('focus', function(){
          this.select();
        });

      	// attach an event to recalculate whenever an input element changes
      	priceInput.bind('change', function(){
      	  var total = 0;
          jQuery(recipe).children('dd').each(function(){
            total += parseInt(jQuery(this).children('var.quantity').text(),10) * parseFloat(jQuery(this).children('input').attr('value'), 10);
          });
          
          var totalCurrency = new Currency(total);
          jQuery(recipe).find('dt strong').html(totalCurrency.tags());
      	});
      	          
        jQuery(this).append(priceInput);
      }
    });
  };
  
  jQuery('dl.recipe').recipe();
  
});
