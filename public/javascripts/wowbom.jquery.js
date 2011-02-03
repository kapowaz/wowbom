// A set of methods for interacting with crafting recipe data from wowhead.com

jQuery(document).ready(function() {
	// convert a float value into gold, silver and copper values
	wowGold = function(fltGold){
		var currency = {
			gold: 0,
			silver: 0,
			copper: 0
		};
		fltGold = parseFloat(fltGold, 10);
		currency.gold = Math.floor(fltGold);
		currency.silver = Math.floor((fltGold-currency.gold)*100);
		currency.copper = Math.floor((((fltGold-currency.gold)*100) - currency.silver)*100);
		return currency;
	};

	// format a wow gold object into a sequence of <var> elements with appropriate classnames
	formatGold = function(objCurrency){
		var htmlGold = '<var class="gold">'+objCurrency.gold+'</var>';
		var htmlSilver = '<var class="silver">'+objCurrency.silver+'</var>';
		var htmlCopper = '<var class="copper">'+objCurrency.copper+'</var>';
		
		// determine which parts of the currency value to display
		if (objCurrency.gold == 0) {
			if (objCurrency.silver == 0) {
				return htmlCopper;
			} else {
				return objCurrency.copper == 0 ? htmlSilver : htmlSilver + htmlCopper;
			}
		} else {
			if (objCurrency.silver == 0) {
				return objCurrency.copper == 0 ? htmlGold : htmlGold + htmlSilver + htmlCopper;
			} else {
				return objCurrency.copper == 0 ? htmlGold + htmlSilver : htmlGold + htmlSilver + htmlCopper;
			}
		}
	};

	urlId = function(strURL) {
		return strURL.match(/http:\/\/www.wowhead.com\/\?item=([0-9]+)/)[1];
	};

	// recalculate the cost of crafting a recipe based on data in the DOM
	calculateRecipeCost = function(recipeDL){
		var rrp = 0;
		jQuery(recipeDL).children('dd').each(function(){
			if (jQuery(this).children('input').length == 0) {		
				var itemid = urlId(jQuery(this).children('a').attr('href'));
				var itemprice = jQuery(this).children('a').attr('price');						
				jQuery(this).append(jQuery('<input type="text" id="item'+itemid+'" value="'+itemprice+'" class="price" />'));	
				//jQuery(this).append('<strong class="rrp">'+formatGold(wowGold(itemprice))+'</strong>');
			}
			rrp += parseInt(jQuery(this).children('var').text(),10) * parseFloat(jQuery(this).children('input').attr('value'), 10);
		});
		jQuery(recipeDL).children('dt').children('strong').html(formatGold(wowGold(rrp)));
	};
	
	// retrieve data for a given reagent
	reagentData = function(reagentId) {
		var reagent = {};
		jQuery(reagents).each(function(){
			if (this.id == reagentId) {
				reagent = this;
			}
		});
		return reagent;
	};
	
	// retrieve recipe data by recipe name
	recipeByName = function(recipeName) {
		var recipe = {};
		jQuery(recipes).each(function(){
			if (this.name == recipeName) {
				recipe = this;
			}
		});
		return recipe;
	};
	
	// retrieve recipe data by recipe ID
	recipeById = function(recipeId) {
		var recipe = {};
		jQuery(recipes).each(function(){
			if (this.id == recipeId) {
				recipe = this;
			}
		});
		return recipe;
	};
	
	// generate a full tooltip for a given recipe
	generateRecipe = function(objRecipe) {
		var recipe = jQuery('<dl class="recipe" rel="'+objRecipe.id+'"></dl>');
		jQuery(recipe).append('<dt>'+(objRecipe.quantity ? '<var class="quantity">'+objRecipe.quantity+'×</var> ':'')+'<a href="http://www.wowhead.com/?item='+objRecipe.id+'" class="'+(objRecipe.quality ? objRecipe.quality : 'epic')+'">'+objRecipe.name+'</a></dt>');
		if (objRecipe.slot) { jQuery(recipe).append('<dt>'+objRecipe.slot+'</dt>'); }
		
		jQuery(recipe).children('dt').append('<strong class="rrp"></strong>');
		jQuery(objRecipe.reagents).each(function(){
			var reagent = reagentData(this.id);
			jQuery(recipe).append('<dd><var class="quantity">'+this.quantity+'</var> <a href="http://www.wowhead.com/?item='+this.id+'" class="'+reagent.quality+'" price="'+reagent.price+'">'+reagent.name+'</a></dd>');
		});
		return recipe;
	};
	
});