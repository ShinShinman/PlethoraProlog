class Plethora
	@settings = 
		# Swiper
		forwardSwiper: $('.swiper-container .forward')
		backwardSwiper: $('.swiper-container .backward')

	# Private methods
	apiTest = -> console.log 'API Test'

	# Public methods
	helloWorld: (options) ->
		settings = $.extend( {
			# defaults
			msg: 'Hello!'
			}, options)
		console.log settings.msg

	# public API
	api:
		apiTest: apiTest

	# Init
	init: ->
		console.log '********'
		console.log 'Plethora'
		console.log '********'

window.Plethora = new Plethora()

$ ->
	console.log 'Start'