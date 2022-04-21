# jQuery
$ ->
	forwardSwiperEl = $('.swiper-container.forward .swiper-wrapper');

	infoObj = {
		trg: $('section.info'),
		mode: 'collapsed',
		stage: 'none'
	}
	infoTrigger = {
		trg: infoObj.trg.find('.trigger button'),
		closeBtn: infoObj.trg.find('.layout button.closeBtn')
	}
	app = $('section.app')

	infoObjToggle = (target) ->
		if infoObj.mode == 'expanded' and infoObj.stage == target
			infoObj.mode = 'collapsed'
			infoObj.stage = 'none'
			app.show()
			infoObj.trg.animate({
				height: '0rem',
				paddingTop: 0
			}, 'slow', () ->
					infoObj.trg.find('.layout.' + target).addClass('hidden')
					infoObj.trg.find('.layout').hide()
			)
		else if infoObj.mode == 'expanded' and infoObj.stage isnt target
			infoObj.trg.find('.layout.' + infoObj.stage).addClass('hidden').hide()
			infoObj.trg.find('.layout.' + target).show()
			infoObj.stage = target
			setTimeout () ->
				infoObj.trg.find('.layout.' + target).removeClass 'hidden'
			, 100
		else
			infoObj.mode = 'expanded'
			infoObj.stage = target
			infoObj.trg.find('.layout.' + target).show()
			infoObj.trg.animate({
				height: '90vh'
			}, 1000, () ->
				app.hide()
				infoObj.trg.find('.layout.' + target).removeClass('hidden')
			)
			# infoTrigger.closeBtn.show();

	infoTrigger.trg.click((e) ->
		# infoObj.stage = e.target.classList.value
		infoObjToggle e.target.classList.value
	)
	infoTrigger.closeBtn.click((e) ->
		console.log infoObj.stage
		infoObjToggle infoObj.stage
	)

	$.getJSON('./ajax/slides.json', (data) ->
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
