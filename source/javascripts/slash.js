(function($){

	var mobilenav = $('#mobile-nav');

	$('html').click(function(){
		mobilenav.find('.on').each(function(){
			$(this).removeClass('on').next().hide();
		});
	});

	mobilenav.on('click', '.menu .button', function(){
		if (!$(this).hasClass('on')){
			$(this).addClass('on').next().show();
		} else {
			$(this).removeClass('on').next().hide();
		}
	}).on('click', '.search .button', function(){
		if (!$(this).hasClass('on')){
			mobilenav.children('.menu').children().eq(0).removeClass('on').next().hide();
			$(this).addClass('on').next().show().children().children().eq(0).focus();
		} else {
			$(this).removeClass('on').next().hide().children().children().eq(0).val('');
		}
	}).click(function(e){
		e.stopPropagation();
	});
})(jQuery);
