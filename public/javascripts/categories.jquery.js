$(document).ready(function() {
  jQuery.fn.categoryMenu = function categoryMenu() {
    var menu                      = $(this);
    var menu_category_link        = menu.find('a.category');
    var menu_subcategory_link     = menu.find('a.subcategory');
    var menu_inventoryslot_link   = menu.find('a.inventoryslot');
    var fadeInTimer               = 50;
    var fadeOutTimer              = 100;
    var dismissDelay              = 1000;

    var category_list             = null;
    var subcategory_list          = null;
    var inventoryslot_list        = null;

    var categoryTimer             = null;
    var subcategoryTimer          = null;
    var inventoryslotTimer        = null;

    var subcategorySubMenuTimer   = null;
    var inventoryslotSubMenuTimer = null;

    // pull out all the inventoryslots
    var inventoryslots_armor    = {};
    jQuery.map(inventory_slots, function(slot, i){ if (slot['armor']) inventoryslots_armor[i] = slot; });

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
    
    var showSubMenu = function showSubMenu(e) {
      clearTimeout(subcategorySubMenuTimer);
      clearTimeout(inventoryslotSubMenuTimer);
      
      var submenu = $(e.target).siblings('ul.sub.menu');
      
      switch ($(e.target).closest('ul.menu').attr('data-menu')) {
        case 'category':
          others = $('ul[data-submenu=subcategory]');
          break;
        case 'subcategory':
          others = $('ul[data-submenu=inventoryslot]');
          break;
      }
      
      var other_visible = null;
      jQuery.each(others, function(i, other_menu){
        other_menu = $(other_menu);
        if (other_menu.is(':visible')) {
          other_visible = other_menu;
        }
      });
      
      if (other_visible) {
        other_visible.fadeOut(fadeInTimer, function(){
          submenu.fadeIn(fadeInTimer);
        });
      } else {
        submenu.fadeIn(fadeInTimer);
      }
    };
      
    var hideMenu = function hideMenu(menu) {
      var timer = setTimeout(function(){
        // console.log('hideMenu');
        menu.fadeOut(fadeOutTimer);
      }, dismissDelay);
      
      switch (menu.attr('data-menu')) {
        case 'category':
          categoryTimer = timer;
          break;
        case 'subcategory':
          subcategoryTimer = timer;
          break;
        case 'inventoryslot':
          inventoryslotTimer = timer;
          break;
      }
    };
    
    var hideSubMenu = function hideSubMenu(e) {
      var submenu = $(e.target).siblings('ul.sub.menu');
      
      var timer = setTimeout(function(){
        // console.log('hideSubMenu');
        submenu.fadeOut(fadeOutTimer);
      }, dismissDelay);
      
      switch (submenu.attr('data-submenu')) {
        case 'subcategory':
          subcategorySubMenuTimer = timer;
          break;
        case 'inventoryslot':
          inventoryslotSubMenuTimer = timer;
          break;
      }
    };
    
    var hideOrphanSubMenus = function hideOrphanSubMenus(e) {
      // console.log('hideOrphanSubMenus');
      if ($(e.target).siblings('ul.sub.menu').length == 0) {
        $(e.target).closest('ul').find('ul.sub.menu').fadeOut(fadeInTimer);
      }
    };

    // generate a menu from a list of items
    var generateMenu = function generateMenu(items, options) {
      // options = {
      //   baseURL:   <string, base url of links>,
      //   listClass: <string, class added to the ul>,
      //   name:      <string, name of the menu, used throughout>,
      //   menuStyle: <associative array, optional CSS to add to the menu>,
      //   submenu:   <boolean, optional to indicate a submenu>
      // }
      
      var list = $('<ul></ul>');
      
      list.addClass(options.submenu ? 'sub menu' : 'menu');
      list.addClass(options.className);
      list.attr(options.submenu ? 'data-submenu' : 'data-menu', options.name);
      
      jQuery.each(items, function(id, item){
        var item_link     = $('<a href="' + options.baseURL + '/' + item.slug + '">' + item.name + '</a>');
        var list_item     = $('<li></li>');
        var submenu_items = null;
        var submenu_class = null;
        var submenu_name  = null;

        // generate a submenu for this item, if one exists
        switch (options.name) {
          case 'category':
            // => subcategories
            if (item.subcategories) {
              submenu_items = item.subcategories;
              submenu_class = 'subcategories';
              submenu_name  = 'subcategory';
              item_link.addClass('sub'); 
            }
            break;
          case 'subcategory':
            // => inventory slots
            // only if this item has an inventoryslots key value of true
            if (item.inventoryslots) {
              submenu_items = inventoryslots_armor;
              submenu_class = 'inventoryslots';
              submenu_name  = 'inventoryslot';
              item_link.addClass('sub');
            }
            break;
        }

        if (submenu_items) {
          // generate submenu...
          submenu = generateMenu(submenu_items, {
            baseURL:   options.baseURL + '/' + item.slug,
            listClass: submenu_class,
            name:      submenu_name,
            menuStyle: {'margin-left': '170px', 'margin-top': '-6px'},
            submenu:   true
          });
          list_item.append(submenu);
          item_link.bind('mouseover', showSubMenu);
          item_link.bind('mouseout', hideSubMenu);
        }
        if (options.submenu != true) item_link.bind('mouseover', hideOrphanSubMenus);
        
        list_item.attr('data-' + options.name + '-id', id);
        list_item.append(item_link);
        list.append(list_item);
      });
      list.bind('mouseover', function(){ clearTimeout(eval(options.name + (options.submenu ? 'SubMenu' : '') + 'Timer')); });
      if (options.submenu != true) list.bind('mouseout', function(){ hideMenu(list); });
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
      baseURL:   '/category/' + category.slug + '/' + subcategory.slug,
      listClass: 'inventoryslots',
      name:      'inventoryslot',
      menuStyle: {'margin-left': (menu_category_link.width() + menu_subcategory_link.width() + 61) + 'px'}
    });
    
    menu.after(inventoryslot_list);
    menu_inventoryslot_link.bind('mouseover', function(){ showMenu(inventoryslot_list); });
    menu_inventoryslot_link.bind('mouseout', function(){ hideMenu(inventoryslot_list); });
  };
  
  $('div#categories').categoryMenu();
  
});
