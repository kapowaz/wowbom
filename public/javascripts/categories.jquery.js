$(document).ready(function() {
  
  jQuery.fn.categoryMenu = function categoryMenu() {
    var menu                    = $(this);
    var menu_category_link      = menu.find('a.category');
    var menu_subcategory_link   = menu.find('a.subcategory');
    var menu_inventoryslot_link = menu.find('a.inventoryslot');
    
    // first, retrieve all the categories and inventory slots
    jQuery.getJSON('/categories.json', function(categories){
      jQuery.getJSON('/inventory_slots.json', function(inventory_slots){
        
        var category_list      = $('<ul class="menu categories" data-menu="category"></ul>');
        var subcategory_list   = $('<ul class="menu subcategories" data-menu="subcategory"></ul>');
        var inventoryslot_list = $('<ul class="menu inventoryslots" data-menu="inventoryslot"></ul>');
        var categoryTimer      = null;
        var subcategoryTimer   = null;
        var inventoryslotTimer = null;

        var showMenu = function showMenu(menu) {
          clearTimeout(categoryTimer);
          clearTimeout(subcategoryTimer);
          clearTimeout(inventoryslotTimer);

          switch (menu.attr('data-menu')) {
            case 'category':
              others = [subcategory_list, inventoryslot_list];
              break;
            case 'subcategory':
              others = [category_list, inventoryslot_list];
              break;
            case 'inventoryslot':
              others = [category_list, subcategory_list];
              break;
          }

          if (others[0].is(':visible')) {
            others[0].fadeOut('fast', function(){
              menu.fadeIn('fast');
            });
          } else if (others[1].is(':visible')) {
            others[1].fadeOut('fast', function(){
              menu.fadeIn('fast');
            });
          } else {
            menu.fadeIn('fast');
          }
        };

        var hideMenu = function hideMenu(menu) {
          switch (menu.attr('data-menu')) {
            case 'category':
              categoryTimer = setTimeout(function(){
                menu.fadeOut('fast');
              }, 500);
              break;
            case 'subcategory':
              subcategoryTimer = setTimeout(function(){
                menu.fadeOut('fast');
              }, 500);
              break;
            case 'inventoryslot':
              inventoryslotTimer = setTimeout(function(){
                menu.fadeOut('fast');
              }, 500);
              break;
          }
        };

        // generate a list of all top-level categories
        jQuery.each(categories, function(id, category){
          var category_link = $('<a href="/category/' + category.slug + '">' + category.name + '</a>');
          var category_item = $('<li data-category-id="' + id + '"></li>');
          category_item.append(category_link);
          category_list.append(category_item);
        }); // jQuery.each(categories)      
        category_list.bind('mouseover', function(){ clearTimeout(categoryTimer); });
        category_list.bind('mouseout', function(){ hideMenu(category_list); });
        category_list.css({display:'none'});
        
        menu.after(category_list);
        menu_category_link.bind('mouseover', function(){ showMenu(category_list); });
        menu_category_link.bind('mouseout', function(){ hideMenu(category_list); });

        // generate a list of subcategories for this category
        category = categories[parseInt(menu_category_link.attr('data-category-id'),10)];
        jQuery.each(category.subcategories, function(id, subcategory){
          var subcategory_link = $('<a href="/category/' + category.slug + '/' + subcategory.slug +'">' + subcategory.name + '</a>');
          var subcategory_item = $('<li data-subcategory-id="' + id + '"></li>');
          subcategory_item.append(subcategory_link);
          subcategory_list.append(subcategory_item);
        });
        subcategory_list.bind('mouseover', function(){ clearTimeout(subcategoryTimer); });
        subcategory_list.bind('mouseout', function(){ hideMenu(subcategory_list); });
        subcategory_list.css({display:'none', 'margin-left': (menu_category_link.width() + 26) + 'px'});
        
        menu.after(subcategory_list);
        menu_subcategory_link.bind('mouseover', function(){ showMenu(subcategory_list); });
        menu_subcategory_link.bind('mouseout', function(){ hideMenu(subcategory_list); });

        // generate a list of all inventory slots
        subcategory = categories[parseInt(menu_category_link.attr('data-category-id'),10)].subcategories[parseInt(menu_subcategory_link.attr('data-subcategory-id'),10)];
        jQuery.each(inventory_slots, function(i, inventoryslot){
          var inventoryslot_link = $('<a href="/category/' + category.slug + '/' + subcategory.slug + '/' + inventoryslot.slug + '">' + inventoryslot.name + '</a>');
          var inventoryslot_item = $('<li data-inventoryslot="' + i + '"></li>');
          inventoryslot_item.append(inventoryslot_link);
          inventoryslot_list.append(inventoryslot_item);
        });
        inventoryslot_list.bind('mouseover', function(){ clearTimeout(inventoryslotTimer); });
        inventoryslot_list.bind('mouseout', function(){ hideMenu(inventoryslot_list); });
        inventoryslot_list.css({display:'none', 'margin-left': (menu_category_link.width() + menu_subcategory_link.width() + 61) + 'px'});
        
        menu.after(inventoryslot_list);
        menu_inventoryslot_link.bind('mouseover', function(){ showMenu(inventoryslot_list); });
        menu_inventoryslot_link.bind('mouseout', function(){ hideMenu(inventoryslot_list); });
        
      }); // jQuery.getJSON(inventory_slots)
    }); // jQuery.getJSON(categories)    
  };
  
  $('div#categories').categoryMenu();
  
});
