$(document).ready(function() {
  jQuery.fn.categoryMenu = function categoryMenu() {
    var menu                    = $(this);
    var menu_category_link      = menu.find('a.category');
    var menu_subcategory_link   = menu.find('a.subcategory');
    var menu_inventoryslot_link = menu.find('a.inventoryslot');
    var fadeInTimer             = 100;
    var fadeOutTimer            = 200;
    var dismissDelay            = 500;
    
    var category_list           = null;
    var subcategory_list        = null;
    var inventoryslot_list      = null;
    var categoryTimer           = null;
    var subcategoryTimer        = null;
    var inventoryslotTimer      = null;

    // reveal the specified menu, fading out any other currently visible menus
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
        others[0].fadeOut(fadeInTimer, function(){
          menu.fadeIn(fadeInTimer);
        });
      } else if (others[1].is(':visible')) {
        others[1].fadeOut(fadeInTimer, function(){
          menu.fadeIn(fadeInTimer);
        });
      } else {
        menu.fadeIn(fadeInTimer);
      }
    };

    var hideMenu = function hideMenu(menu) {
      switch (menu.attr('data-menu')) {
        case 'category':
          categoryTimer = setTimeout(function(){
            menu.fadeOut(fadeOutTimer);
          }, dismissDelay);
          break;
        case 'subcategory':
          subcategoryTimer = setTimeout(function(){
            menu.fadeOut(fadeOutTimer);
          }, dismissDelay);
          break;
        case 'inventoryslot':
          inventoryslotTimer = setTimeout(function(){
            menu.fadeOut(fadeOutTimer);
          }, dismissDelay);
          break;
      }
    };

    // generate a menu from a list of items
    var generateMenu = function generateMenu(items, options) {
      // options = {
      //   baseURL:   <string, base url of links>,
      //   listClass: <string, class added to the ul>,
      //   name:      <string, name of the menu, used throughout>,
      //   menuStyle: <associative array, optional CSS to add to the menu>
      // }
      
      var list = $('<ul class="menu"></ul>');
      
      list.addClass(options.className);
      list.attr('data-menu', options.name);
      jQuery.each(items, function(id, item){
        var item_link = $('<a href="' + options.baseURL + '/' + item.slug + '">' + item.name + '</a>');
        var list_item = $('<li></li>');
        list_item.attr('data-' + options.name + '-id', id);
        list_item.append(item_link);
        list.append(list_item);
      });
      list.bind('mouseover', function(){ clearTimeout(eval(options.name + 'Timer')); });
      list.bind('mouseout', function(){ hideMenu(list); });
      list.css({display:'none'});
      if (options.menuStyle) list.css(options.menuStyle);
      
      return list;
    };
    
    category_list = generateMenu(categories, {
      baseURL:   '/category',
      listClass: 'categories',
      name:      'category'
    });
    menu.after(category_list);
    menu_category_link.bind('mouseover', function(){ showMenu(category_list); });
    menu_category_link.bind('mouseout', function(){ hideMenu(category_list); });
    
    category = categories[parseInt(menu_category_link.attr('data-category-id'),10)];
    subcategory_list = generateMenu(category.subcategories, {
      baseURL:   '/category/' + category.slug,
      listClass: 'subcategories',
      name:      'subcategory',
      menuStyle: {'margin-left': (menu_category_link.width() + 26) + 'px'}
    });
    menu.after(subcategory_list);
    menu_subcategory_link.bind('mouseover', function(){ showMenu(subcategory_list); });
    menu_subcategory_link.bind('mouseout', function(){ hideMenu(subcategory_list); });
    
    subcategory = categories[parseInt(menu_category_link.attr('data-category-id'),10)].subcategories[parseInt(menu_subcategory_link.attr('data-subcategory-id'),10)];
    inventoryslot_list = generateMenu(inventory_slots, {
      baseURL: '/category/' + category.slug + '/' + subcategory.slug,
      listClass: 'inventoryslots',
      name: 'inventoryslot',
      menuStyle: {'margin-left': (menu_category_link.width() + menu_subcategory_link.width() + 61) + 'px'}
    });
    
    menu.after(inventoryslot_list);
    menu_inventoryslot_link.bind('mouseover', function(){ showMenu(inventoryslot_list); });
    menu_inventoryslot_link.bind('mouseout', function(){ hideMenu(inventoryslot_list); });
  };
  
  $('div#categories').categoryMenu();
  
});
