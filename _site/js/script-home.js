
  $(document).ready(function(){    
  $("#navigation").stop().animate({opacity: '0'},0);      
  $(".social-links").stop().animate({opacity: '0'},0);  

  $("body").stop().animate({opacity: '100'},10000);  
  $(".social-links").stop().animate({opacity: '100'},10000);  

 $('#navigation').hover(function() {
 $("#navigation").stop().animate({opacity: '100'},'slow');

  return false;
});

  $("#navigation").stop().animate({opacity: '50'},85000);  
});







