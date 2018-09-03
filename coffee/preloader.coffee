console.log ('start')
id = (v) -> document.getElementById(v)
loadbar = () ->
	console.log ('loadBar')
	ovrl = id("overlay")
	prog = id("progress")
	stat = id("progstat")
	img = document.images
	console.log(img)
	c = 0
	tot = img.length
	if tot == 0 then doneLoading()

imgLoaded = () ->
	c += 1
	perc = ((100/tot*c) << 0) +"%"
	console.log (perc)
	#prog.style.width = perc
	#stat.innerHTML = "Loading "+ perc;
	if c==tot then doneLoading()

doneLoading = () ->
	ovrl.style.opacity = 0
	setTimeout(() ->
		ovrl.style.display = "none"
	, 1200)

for i in [0..tot]
	tImg = new Image()
	tImg.onload = imgLoaded;
	tImg.onerror = imgLoaded
	tImg.src = img[i].src

document.addEventListener('DOMContentLoaded', loadbar, false)