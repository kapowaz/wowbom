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
    var window_height = Math.round($(window).height());
    $('div#wrapper').css({'height': window_height});
	};
	
  resizeWrapper();
	$(window).bind('resize', resizeWrapper);
  $(document).bind('scroll', resizeWrapper);
  
  $('button, a.button').buttonWrapper();
  
  // initially disable the selects for faction and server
  $('input#use_locale').bind('click', function(){
    $(this).blur();
  });
  
  $('select[name=faction], select[name=realm]').attr('disabled', 'disabled');
  
  $('input#use_locale').bind('change', function(){
    if ($(this).is(':checked')) {
      $('select[name=faction], select[name=realm]').removeAttr('disabled');
    } else {
      $('select[name=faction], select[name=realm]').val('average');
      $('select[name=faction], select[name=realm]').attr('disabled', 'disabled');
    }
    // TODO: post the form so as to update settings — important: needs to know which page you were on when you changed your locale settings
  });
  
  // post the form with locale settings whenever the dropdowns change value
  var updateLocaleSettings = function(){
    // TODO: implementation...
  };
  $('select[name=faction], select[name=select]').bind('change', updateLocaleSettings);
  
});
