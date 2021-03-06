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
        if (itemLink.attr('data-item-soulbound') == 'true') priceInput.attr('title', 'Since this item binds on pickup, the price will be set by the person crafting');
        
        // select the contents of inputs when focused
        priceInput.bind('focus', function(){
          this.select();
        });

      	// attach an event to recalculate whenever an input element changes
      	priceInput.bind('change', function(){
      	  var total = 0;
          jQuery(recipe).children('dd').each(function(){
            if (jQuery.trim(jQuery(this).children('input').val()) != ""){
              var componentPrice = new Currency(jQuery(this).children('input').val());
              jQuery(this).children('input').val(componentPrice.toString());
              total += parseInt(jQuery(this).children('var.quantity').text(),10) * componentPrice.toNumber(); 
            }
          });
          
          var totalPrice = new Currency(total);
          jQuery(recipe).find('dt strong').html(totalPrice.toHTML());
      	});
      	          
        jQuery(this).append(priceInput);
      }
    });
  };
  
  jQuery('dl.recipe').recipe();
  
});
