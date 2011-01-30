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
  
});
