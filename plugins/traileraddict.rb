module Jekyll
  class Traileraddict < Liquid::Tag

    def initialize(name, id, tokens)
      super
      @id = id
    end

    def render(context)
      %(<div class="embed-video-container"><iframe src="//www.traileraddict.com/emd/#{@id}"></iframe></div>)
    end
  end
end

Liquid::Template.register_tag('traileraddict', Jekyll::Traileraddict)
