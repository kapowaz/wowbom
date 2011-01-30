$(document).ready(function() {

  // browser engine-specific flags
  if ($.browser.mozilla) $('body').addClass('mozilla');
  if ($.browser.webkit) $('body').addClass('webkit');
  if ($.browser.ie) $('body').addClass('ie');

	// generate recipes by ID from those in the page
	jQuery('div.recipe').each(function(){
	  var recipe = $(this);
	  var recipe_id = parseInt(recipe.attr('data-recipe-id'), 10);
	  if (typeof recipe_id == 'number') {
	    recipe.replaceWith(generateRecipe(recipeById(recipe_id)));
	  }
	});

	// execute once on every recipe
	jQuery('dl.recipe').each(function(){
		calculateRecipeCost(this);
	});

	// select the text within any input that gets focused
	jQuery('dl.recipe dd input').focus(function(){
		this.select();
	});

	// attach an event to recalculate whenever an input element changes
	jQuery('dl.recipe dd input').change(function(){
		calculateRecipeCost(jQuery(this).parent('dd').parent('dl'));
	});
	
	var resizeWrapper = function(){
    var window_height = Math.round($(window).height()) - 10;
    $('div#wrapper').css({'height': window_height});
	};
	
  resizeWrapper();
	$(window).bind('resize', resizeWrapper);

  $('button, a.button').buttonWrapper();

});
