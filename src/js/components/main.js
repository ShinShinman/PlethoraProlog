(function() {
  // jQuery
  $(function() {
    var forwardSwiperEl, infoObj, infoObjToggle, infoTrigger;
    forwardSwiperEl = $('.swiper-container.forward .swiper-wrapper');
    infoObj = {
      trg: $('section.info'),
      mode: 'colapsed'
    };
    infoTrigger = {
      trg: infoObj.trg.find('.trigger button'),
      closeBtn: infoObj.trg.find('.trigger button .close')
    };
    infoObjToggle = function() {
      if (infoObj.mode === 'expanded') {
        infoObj.mode = 'colapsed';
        infoObj.trg.animate({
          height: '2.5rem',
          paddingTop: 0
        }, 'slow');
        return infoTrigger.closeBtn.hide();
      } else {
        infoObj.mode = 'expanded';
        infoObj.trg.animate({
          height: '95vh',
          paddingTop: '2.5rem'
        }, 1000);
        return infoTrigger.closeBtn.show();
      }
    };
    infoTrigger.trg.click(function(e) {
      return infoObjToggle();
    });
    return $.getJSON('ajax/slides.json', function(data) {
      var allFWImgs, allImgs, forwardSwiper, slides, swiperOptions;
      slides = [];
      $.each(data.slides, function(key, slide) {
        var slideTemplate;
        slideTemplate = `<div class="swiper-slide">
	<img src="images/${slide.image}_x1.png" alt="" srcset="images/${slide.image}_x1.png 1x, images/${slide.image}_x2.png 2x, images/${slide.image}_x3.png 3x">
	<div class="text-column">
		<p>${slide.description}</p>
	</div>
</div>`;
        forwardSwiperEl.append(slideTemplate);
        return slides.push(slide);
      });
      swiperOptions = {
        noSwipingClass: 'swiper-slide',
        loop: true,
        pagination: {
          type: 'fraction'
        }
      };
      forwardSwiper = new Swiper('.swiper-container.forward', {
        allowTouchMove: false,
        loop: true,
        pagination: {
          el: '.counter .forward-counter',
          type: 'fraction'
        },
        on: {
          transitionStart: function() {
            return $('.swiper-slide-active .text-column').hide();
          },
          transitionEnd: function() {
            return $('.swiper-slide-active .text-column').fadeIn();
          }
        }
      });
      $('.swiper-container .button.rew').click(function() {
        return forwardSwiper.slidePrev();
      });
      $('.swiper-container .button.ff').click(function() {
        return forwardSwiper.slideNext();
      });
      if ($(window).width() < 968) {
        forwardSwiper.allowTouchMove = true;
      }
      $(window).resize(function() {
        if ($(window).width() < 968) {
          return forwardSwiper.allowTouchMove = true;
        }
      });
      allImgs = $('.swiper-slide img'); // [TJNP] – chyba
      allFWImgs = $('.forward').find('.swiper-slide img');
      return $(document).keydown(function(e) {
        if (e.keyCode === 37) {
          return forwardSwiper.slidePrev();
        } else if (e.keyCode === 39) {
          return forwardSwiper.slideNext();
        } else if (e.keyCode === 32) {
          e.preventDefault();
          return infoObjToggle();
        }
      });
    });
  });

  window.onload = function() {
    return $('.preloader').fadeOut();
  };

}).call(this);

//# sourceMappingURL=main.js.map
