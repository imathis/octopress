module Jekyll
  class DailyMotion < Liquid::Tag
    def initialize(name, id, tokens)
      super
      @id = id
    end
    def render(context)
	%(<div class="embed-video-container"><iframe src="//www.dailymotion.com/embed/video/#{@id}"></iframe></div>)
    end
  end
end
Liquid::Template.register_tag('dailymotion', Jekyll::DailyMotion)
