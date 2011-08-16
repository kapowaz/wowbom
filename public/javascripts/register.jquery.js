$(document).ready(function() {
  
  var register_rules = {
    login: {
      required: true, 
      minlength: 6, 
      maxlength: 20,
      remote: {
        url: '/available/login', 
        type: 'post', 
        data: { 
          email: function(){
            return $('input#registration_login').val();
          }
        }
      }
    },
    email: {
      required: true, 
      email: true, 
      remote: {
        url: '/available/email', 
        type: 'post', 
        data: { 
          email: function(){
            return $('input#registration_email').val();
          }
        }
      }
    },
    password: {required: true},
    password_confirmation: {required: true, equalTo: '#registration_password'}
  };
  
  var register_messages = {
    login: {
      required: 'You need to choose a login name', 
      minlength: 'Your login name needs to be between 6 and 20 characters long', 
      maxlength: 'Your login name needs to be between 6 and 20 characters long',
      remote: 'Somebody has already registered using that login name'
    },
    email: {
      required: 'You need to provide your email address',
      email: 'That doesn\'t look like an email address',
      remote: 'Somebody has already registered using that email address'
    },
    password: {
      required: 'You need to enter a password'
    },
    password_confirmation: {
      required: 'You need to confirm your password by typing it again here',
      equalTo: 'Password and confirmation need to be the same'
    }
  };
  
  // $('form#register_user dt.submit input[type=submit]').addClass('disabled').attr('disabled', 'disabled');
  $('form#register_user').validate({
    rules:          register_rules,
    messages:       register_messages
  });
  
  // $('form#register_user input').bind('change blur', function(e){
  //   var error_label = $(e.target).siblings('label.error');
  //   if (error_label.is(':visible') && error_label.css('display') == 'block') error_label.css('display', 'inline-block');
  // });
  
  // $('form#register_user input').bind('blur', function(e){
  //   $(e.target).siblings('label.error').css('display', 'none !important');
  // });
  // 
  // $('form#register_user input').bind('focus', function(e){
  //   $(e.target).siblings('label.error').css('display', 'inline-block !important');
  // });
  
});
