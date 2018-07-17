# jQuery
$ ->
	forwardSwiperEl = $('.swiper-container.forward .swiper-wrapper');
	backwardSwiperEl = $('.swiper-container.backward .swiper-wrapper');

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
				height: '100vh',
				paddingTop: '3.5rem'
			}, 1000);
			infoTrigger.closeBtn.show();

	infoTrigger.trg.click((e) ->
		infoObjToggle();
	)

	$.getJSON('ajax/slaids.json', (data) ->
		slides = []
		$.each data.slides, (key, slide) ->
			slideTemplate = '<div class="swiper-slide">' +'<img src="images/' + slide.image + '_480.png" alt="" ' +'srcset="images/' + slide.image + '_480.png 1x, images/' + slide.image + '_960.png 2x, images/' + slide.image + '_1440.png 3x">' +'<div class="text-column">' +'<h1>' + slide.title + '</h1>' +'<p>' + slide.description + '</p>' +'<p class="note">' + slide.note + '</p>' +'</div></div>'

			forwardSwiperEl.append(slideTemplate);
			backwardSwiperEl.append(slideTemplate);
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
			}
		})
		$('.forward .swiper-wrapper .swiper-slide').click( () ->
			forwardSwiper.slideNext()
		)

		backwardSwiper = new Swiper('.swiper-container.backward', {
			initialSlide: slides.length - 1,
			allowTouchMove: false,
			loop: true,
			pagination: {
				el: '.counter .backward-counter',
				type: 'fraction'
			}	
		})

		$('.backward .swiper-wrapper .swiper-slide').click(() ->
			backwardSwiper.slidePrev()
		)

		if $(window).width() < 968
			forwardSwiper.allowTouchMove = true

		$(window).resize(() ->
			if $(window).width() < 968
				forwardSwiper.allowTouchMove = true
		)

		allImgs = $('.swiper-slide img')
		allFWImgs = $('.forward').find('.swiper-slide img')
		allBWImgs = $('.backward').find('.swiper-slide img')
		trg = $('.forward-button, .backward-button')

		switchImgs = (mode) ->
			trg.text(mode)
		
		$('.forward-button').click((e) ->
			allFWImgs.fadeToggle()
			trg = $(this)
			if $(this).data().mode == 'image' 
				$(this).text('image').data().mode = 'text'
			else 
				$(this).text('text').data().mode = 'image'
		)

		$('.backward-button').click((e) ->
			allBWImgs.fadeToggle()
			trg = $(this)
			if $(this).data().mode == 'image'
				$(this).text('image').data().mode = 'text'
			else
				$(this).text('text').data().mode = 'image'
		)

		$(document).keydown((e) ->
			if e.keyCode == 37
				backwardSwiper.slidePrev()
			else if e.keyCode == 39
				forwardSwiper.slideNext()
			else if e.keyCode == 38
				allImgs.fadeOut()
				switchImgs('image')
			else if e.keyCode == 40
				allImgs.fadeIn()
				switchImgs('text')
			else if e.keyCode == 32
				e.preventDefault()
				infoObjToggle()
		)
	)		
