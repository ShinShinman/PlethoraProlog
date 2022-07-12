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

	### PANELE ###
	panels = {
		projects: infoObj.trg.find('article.projects'),
		projectsSidenav: infoObj.trg.find('article.projects nav.sidenav ul'),
		about: infoObj.trg.find('article.about'),
		aboutSidenav: infoObj.trg.find('article.about nav.sidenav ul')
	}

	infoObjToggle = (target) ->
		targetObj = infoObj.trg.find '.layout.' + target
		if infoObj.mode == 'expanded' and infoObj.stage == target
			infoObj.mode = 'collapsed'
			infoObj.stage = 'none'
			app.show()
			infoObj.trg.animate({
				height: '0rem',
				paddingTop: 0
			}, 0, () ->
					targetObj.addClass('hidden')
					infoObj.trg.find('.layout').hide()
			)
		else if infoObj.mode == 'expanded' and infoObj.stage isnt target
			infoObj.trg.find('.layout.' + infoObj.stage).addClass('hidden').hide()
			targetObj.show()
			infoObj.stage = target
			setTimeout () ->
				targetObj.removeClass 'hidden'
				# targetObj.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', (e) ->
				# 	$(this).removeClass 'camo'
				# )
				$.each infoObj.trg.find("article.#{target} h2"), (k, i) ->
					$('.layout').scrollTop 0
					$(i).data('pos', Math.round $(i).offset().top - 160 )
			, 100
		else
			infoObj.mode = 'expanded'
			infoObj.stage = target
			targetObj.show()
			infoObj.trg.animate({
				height: window.innerHeight - 70
			}, 0, () ->
				app.hide()
				targetObj.removeClass('hidden')
				# targetObj.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', (e) ->
				# 	$(this).removeClass 'camo'
				# )
				$.each infoObj.trg.find("article.#{target} h2"), (k, i) ->
					$('.layout').scrollTop 0
					$(i).data('pos', Math.round $(i).offset().top - 160 )
			)

	infoTrigger.trg.click((e) ->
		infoObjToggle e.target.classList.value
	)
	infoTrigger.closeBtn.click((e) ->
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
		)
	)

	infoTemplate = (item) ->
		"""
			<dl>
		    <dt>#{item.title}</dt>
		    <dd class="place">#{item.place}</dd>
		    <dd class="award">#{item.award}</dd>
		    <dd class="scope">#{item.scope}</dd>
		    <dd class="comment">#{item.comment}</dd>
				<dd class="paragraph">#{item.paragraph}</dd>
		  </dl>
		"""

	$.getJSON('./ajax/projects.json', (data) ->
		headersSet = new Set
		$.each data.projects, (key, project) ->
			if !(headersSet.has(project.header))
				headersSet.add project.header
				panels.projects.append "<h2 id=#{project.header}>#{project.header}</h2>"
				$('.projects nav.sidenav ul').append("<li><a data-target=projects href=##{project.header}>#{project.header}</a></li>")

			panels.projects.append infoTemplate project

		$('.projects nav.sidenav a').click (e) ->
			e.preventDefault()
			scrollTo($(e.target).attr('href'), $(e.target).data('target'))
	)

	$.getJSON('./ajax/about.json', (data) ->
		headersSet = new Set
		$.each data.about, (key, article) ->
			if !(headersSet.has(article.header))
				headersSet.add article.header
				panels.about.append "<h2 id=#{article.header}>#{article.header}</h2>"
				$('.about nav.sidenav ul').append("<li><a data-target=about href=##{article.header}>#{article.header}</a></li>")

			panels.about.append infoTemplate article

		$('.about nav.sidenav a').click (e) ->
			e.preventDefault()
			scrollTo($(e.target).attr('href'), $(e.target).data('target'))
	)

	# MAŁE MENU W PANELU (NAGŁOWKI H2)
	scrollTo = (bookmark, target) ->
		$('.layout.' + target).animate({
			scrollTop: $("h2#{bookmark}").data 'pos'
		}, 500)

	# iNFORMACJA O CIASTECZKACH, COOKIE-STUFF
	if document.cookie.search('cookieConsent=true') >=0
		$('.cookie-stuff').hide()

	cookieConsent = () ->
		exDate = new Date()
		exDate.setTime exDate.getTime() + 90*24*60*60*1000
		expires = 'expires=' + exDate.toUTCString()
		document.cookie = "cookieConsent=true; #{expires}; path=/"

	$('.cookie-stuff button').click( () ->
		cookieConsent()
		$(this).parent().hide()
	)


window.onload = ->
	$('.preloader').fadeOut()
