$(document).ready(function() {
  
  jQuery.fn.buttonWrapper = function buttonWrapper() {
    $(this).each(function(){
      var button = $(this);
      if (button.children('span').length == 0 && button.children('i').length == 0)
      {
        if (this.nodeName == 'BUTTON' || (this.nodeName == 'A' && $(this).hasClass('button')))
        {
          $(this).wrapInner('<span></span>').append('<i></i>');
          if (button.hasClass('search')) button.children('span').append('<b>\u2192</b>');
          button.bind('click.button', function(){ $(this).blur(); });
        }
      }
    });
  };
  
  jQuery.fn.centerLayer = function(resize){
    var window_scrolltop = Math.round($(window).scrollTop());
    var window_height    = Math.round($(window).height());
    var window_width     = Math.round($(window).width());
    var layer_height     = Math.round($(this).height());
    var layer_width      = Math.round($(this).width());
    
    $(this).css({
      'top': (window_scrolltop + ((window_height - layer_height)/2)) + 'px',
      'left': ((window_width - layer_width) / 2) + 'px'
    });
  }; // jQuery.fn.centerLayer();
  
  jQuery.fn.spinner = function(callback){
    var spinner = $('<div class="spinner"></div>');
    spinner.sprite({fps: 24, no_of_frames: 6}).active();
    spinner.css('display', 'none');
    $(this).append(spinner);
    
    spinner.centerLayer();
    spinner.fadeIn(400, function(){
      if (callback != null) callback();
    });
    
    $(window).bind('resize.modallayer scroll.modallayer', function(){
      spinner.centerLayer();
    });
    
  }; // jQuery.fn.spinner();
    
});
