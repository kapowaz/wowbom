$(document).ready(function() {

  // browser engine-specific flags
  if ($.browser.mozilla) $('body').addClass('mozilla');
  if ($.browser.webkit) $('body').addClass('webkit');
  if ($.browser.ie) $('body').addClass('ie');
  
  $('button, a.button').buttonWrapper();
  
  // initially disable the selects for faction and server
  $('input#use_locale').bind('click', function(){
    $(this).blur();
  });
  
  $('select[name=faction], select[name=realm]').prop('disabled', true);
  
  $('input#use_locale').bind('change', function(){
    if ($(this).is(':checked')) {
      $('select[name=faction], select[name=realm]').prop('disabled', false);
    } else {
      $('select[name=faction], select[name=realm]').val('average');
      $('select[name=faction], select[name=realm]').prop('disabled', true);
    }
    // TODO: post the form so as to update settings — important: needs to know which page you were on when you changed your locale settings
  });
  
  // post the form with locale settings whenever the dropdowns change value
  var updateLocaleSettings = function(){
    $(this).blur();
    // TODO: post the form as above...
  };
  $('select[name=faction], select[name=select]').bind('change', updateLocaleSettings);
  
  // disable/enable the search button depending on whether or not it has a value
  $('input#query').bind('keyup change', function(){
    if ($(this).val().length > 0) {
      $(this).removeClass('empty');
      $('button[name=submit]').removeClass('disabled').removeAttr('disabled');
    } else {
      $(this).addClass('empty');
      $('button[name=submit]').addClass('disabled').attr('disabled', 'disabled');      
    }
  });
  
});
