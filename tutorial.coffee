translate = require "t7e"
User = require "zooniverse/models/user"

slides = [
  {
    image: "./images/tutorial-kelp-1.jpg"
    title: translate "tutorial.step1.header"
    content: translate "tutorial.step1.content"
  }, 
  {
    image: './gifs/kelp-tut.gif'
    title: translate "tutorial.step2.header"
    content: translate "tutorial.step2.content"
  }, 
  {
    image: "./gifs/kelp-tut-delete.gif"
    title: translate "tutorial.step3.header"
    content: translate "tutorial.step3.content"
  },
  {
    image: './images/clouds-1.jpg'
    title: translate "tutorial.step4.header"
    content: translate "tutorial.step4.content"
  },
  {
    image: './images/tutorial-kelp.jpg'
    title: translate "tutorial.step5.header"
    content: translate "tutorial.step5.content"
  }
]

class Tutorial
  html = """
    <div id='tutorial'>
      <div class='tutorial-slide'>
        <button id='close'><span id='skip'>#{translate 'tutorial.skip'}</span><img id='tut-x-icon' src='./icons/x-icon.svg'></button>

        <div id='slides-container'></div>

        <button id='next'>#{translate 'tutorial.next'}</button>
        <div class='dots'></div>
      </div>
    </div>
  """

  create: ->
    $(".readymade-classify-page").append(html)
    @dots = $("#tutorial").find(".dots")

    for slide, i in slides
      $("#tutorial #slides-container").append("""
        <div id='slide#{i + 1}'>
          <div class='top-half'>
            <img src=#{slide.image}>
          </div>

          <div class='bottom-half'>
            <h1>#{slide.title}</h1>
            <p>#{slide.content}</p>
          </div>
        </div>
      """)
      @dots.append("<div class='dot'></div>")

  constructor: ->
    @create()
    @el = $("#tutorial").hide()

    @nextBtn = @el.find("button#next")
    @closeBtn = @el.find("button#close")
    @dot = @el.find(".dot")

    @closeBtn.on 'click', => @exit()
    @nextBtn.on 'click', => @onClickNext()
    @dot.on 'click', (e) => @showSlide @el.find(e.target).index() + 1

    @numberOfSlides = slides.length

  start: ->
    @el.fadeIn(250)
    @showSlide(1)
    window.addEventListener "click", @exitIfClickOutside

  exitIfClickOutside: (e) => @exit() if e.target.id is "tutorial"

  currentSlide: -> @el.find('.dot.active').index() + 1

  showSlide: (num) ->
    @el.find("#slide#{num}").show().siblings().hide()
    @el.find(".dot:nth-child(#{num})").addClass("active").siblings().removeClass("active")

    @nextBtn.html(if num is @numberOfSlides then translate 'tutorial.finish' else translate 'tutorial.next')

  onClickNext: ->
    if @currentSlide() is @numberOfSlides
      @exit()
    else
      @showSlide(@currentSlide() + 1) 

  exit: ->
    @el.fadeOut(250)
    window.removeEventListener "click", @exitIfClickOutside

  showIfNewUser: ->
    classifyCount = User.current?.preferences?.kelp?.classify_count
    console.log classifyCount
    unless classifyCount
      @start()
      User.current?.setPreference "classify_count", 0

module?.exports = Tutorial
