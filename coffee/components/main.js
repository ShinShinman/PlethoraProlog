(function() {
  // jQuery
  $(function() {
    var backwardSwiperEl, forwardSwiperEl, infoObj, infoObjToggle, infoTrigger;
    forwardSwiperEl = $('.swiper-container.forward .swiper-wrapper');
    backwardSwiperEl = $('.swiper-container.backward .swiper-wrapper');
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
          height: '100vh',
          paddingTop: '3.5rem'
        }, 1000);
        return infoTrigger.closeBtn.show();
      }
    };
    infoTrigger.trg.click(function(e) {
      return infoObjToggle();
    });
    return $.getJSON('ajax/slaids.json', function(data) {
      var allBWImgs, allFWImgs, allImgs, backwardSwiper, forwardSwiper, slides, swiperOptions, switchImgs, trg;
      slides = [];
      $.each(data.slides, function(key, slide) {
        var slideTemplate;
        slideTemplate = '<div class="swiper-slide">' + '<img src="images/' + slide.image + '_480.png" alt="" ' + 'srcset="images/' + slide.image + '_480.png 1x, images/' + slide.image + '_960.png 2x, images/' + slide.image + '_1440.png 3x">' + '<div class="text-column">' + '<h1>' + slide.title + '</h1>' + '<p>' + slide.description + '</p>' + '<p class="note">' + slide.note + '</p>' + '</div></div>';
        forwardSwiperEl.append(slideTemplate);
        backwardSwiperEl.append(slideTemplate);
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
        }
      });
      $('.forward .swiper-wrapper .swiper-slide').click(function() {
        return forwardSwiper.slideNext();
      });
      backwardSwiper = new Swiper('.swiper-container.backward', {
        initialSlide: slides.length - 1,
        allowTouchMove: false,
        loop: true,
        pagination: {
          el: '.counter .backward-counter',
          type: 'fraction'
        }
      });
      $('.backward .swiper-wrapper .swiper-slide').click(function() {
        return backwardSwiper.slidePrev();
      });
      if ($(window).width() < 968) {
        forwardSwiper.allowTouchMove = true;
      }
      $(window).resize(function() {
        if ($(window).width() < 968) {
          return forwardSwiper.allowTouchMove = true;
        }
      });
      allImgs = $('.swiper-slide img');
      allFWImgs = $('.forward').find('.swiper-slide img');
      allBWImgs = $('.backward').find('.swiper-slide img');
      trg = $('.forward-button, .backward-button');
      switchImgs = function(mode) {
        return trg.text(mode);
      };
      $('.forward-button').click(function(e) {
        allFWImgs.fadeToggle();
        trg = $(this);
        if ($(this).data().mode === 'image') {
          return $(this).text('image').data().mode = 'text';
        } else {
          return $(this).text('text').data().mode = 'image';
        }
      });
      $('.backward-button').click(function(e) {
        allBWImgs.fadeToggle();
        trg = $(this);
        if ($(this).data().mode === 'image') {
          return $(this).text('image').data().mode = 'text';
        } else {
          return $(this).text('text').data().mode = 'image';
        }
      });
      return $(document).keydown(function(e) {
        if (e.keyCode === 37) {
          return backwardSwiper.slidePrev();
        } else if (e.keyCode === 39) {
          return forwardSwiper.slideNext();
        } else if (e.keyCode === 38) {
          allImgs.fadeOut();
          return switchImgs('image');
        } else if (e.keyCode === 40) {
          allImgs.fadeIn();
          return switchImgs('text');
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
