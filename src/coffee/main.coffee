# jQuery
$ ->
	forwardSwiperEl = $('.swiper-container.forward .swiper-wrapper');

	infoObj = {
		trg: $('section.info'),
		mode: 'colapsed'
	}
	infoTrigger = {
		trg: infoObj.trg.find('.trigger button'),
		closeBtn: infoObj.trg.find('.trigger button .close')
	}
	
	infoObjToggle = () ->
		if infoObj.mode == 'expanded'
			infoObj.mode = 'colapsed'
			infoObj.trg.animate({
				height: '2.5rem',
				paddingTop: 0
			}, 'slow')
			infoTrigger.closeBtn.hide()
		else
			infoObj.mode = 'expanded';
			infoObj.trg.animate({
				height: '95vh',
				paddingTop: '2.5rem'
			}, 1000);
			infoTrigger.closeBtn.show();

	infoTrigger.trg.click((e) ->
		infoObjToggle();
	)

	$.getJSON('ajax/slaids.json', (data) ->
		slides = []
		$.each data.slides, (key, slide) ->
			slideTemplate = """
				<div class="swiper-slide">
					<img src="images/#{slide.image}_x1.png" alt="" srcset="images/#{slide.image}_x1.png 1x, images/#{slide.image}_x2.png 2x, images/#{slide.image}_x3.png 3x">
					<div class="text-column">
						<p>#{slide.description}</p>
					</div>
				</div>
				"""

			forwardSwiperEl.append(slideTemplate);
			slides.push(slide);

		swiperOptions = {
			noSwipingClass: 'swiper-slide',
			loop: true,
			pagination: {
				type: 'fraction'
			}
		}

		forwardSwiper = new Swiper('.swiper-container.forward', {
			allowTouchMove: false,
			loop: true,
			pagination: {
				el: '.counter .forward-counter',
				type: 'fraction'
			},
			on: {
				transitionStart: () ->
					$('.swiper-slide-active .text-column').hide()
				transitionEnd: () ->
					$('.swiper-slide-active .text-column').fadeIn()
			}
		})
		$('.swiper-container .button.rew').click( () -> 
			forwardSwiper.slidePrev()
		)
		$('.swiper-container .button.ff').click( () -> 
			forwardSwiper.slideNext()
		)

		if $(window).width() < 968
			forwardSwiper.allowTouchMove = true

		$(window).resize(() ->
			if $(window).width() < 968
				forwardSwiper.allowTouchMove = true
		)

		allImgs = $('.swiper-slide img')  # [TJNP] – chyba
		allFWImgs = $('.forward').find('.swiper-slide img')

		$(document).keydown((e) ->
			if e.keyCode == 37
				forwardSwiper.slidePrev()
			else if e.keyCode == 39
				forwardSwiper.slideNext()
			else if e.keyCode == 32
				e.preventDefault()
				infoObjToggle()
		)
	)

window.onload = ->
	$('.preloader').fadeOut()
