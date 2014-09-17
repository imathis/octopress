$(document).ready(function(){      
  $(".animate").stop().animate({opacity: '0'},0);   
  $(".post-page").stop().animate({opacity: '0'},0);      
  $(".post-page").stop().animate({opacity: '100'},18000);      

  var scroll_pos = 0;
  $(document).scroll(function() { 
    scroll_pos = $(this).scrollTop();
    d = $(document).height(),
    c = $(window).height();
    scroll_percent = (scroll_pos / (d-c)) * 100;

	
    if(scroll_pos > 210) {
      $(".logo").stop().animate({opacity: '.3'},'slow');
      $(".animate").stop().animate({opacity: '0'},'slow');

    } else {
      $(".logo").stop().animate({opacity: '1'},100);
      $(".animate").stop().animate({opacity: '0'},'slow');
    }

    $('.sidebar').on('mouseover', function () {
      $(".sidebar").stop().animate({opacity: '1'},100); 
    });


    if(scroll_pos < 100) {
      $(".cover-image").stop().animate({opacity: '1'},'slow');
    }
    else {
     // $(".social-links").stop().animate({opacity: '0'},'slow');
      $(".cover-image").stop().animate({opacity: '.18'},'slow');
    }

    if(scroll_percent > 80) {
     $(".logo").stop().animate({opacity: '1'},'fast'); 
     $(".animate").stop().animate({opacity: '1'},'slow');

    }
  });








  $('.sidebar').hover(function() {
  $(".social-links").stop().animate({opacity: '1'},'fast');
 $(".logo").stop().animate({opacity: '1'},'fast');

  return false;
});


  $('.go-to-post').click(function() {
  $("html, body").animate({ scrollTop: $('#post-content').offset().top }, 500);
  return false;
});

  $('.scroll').click(function(){
    $("html, body").animate({ scrollTop: 0 }, "fast");
    return false;
  });

/*
 $('.logo').on('mouseover', function () {
  $(".logo").airport(['Ravi','Robins']);
});*/

});








