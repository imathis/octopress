BASE_DIR = 'source/images/galleries'

module ImageList
  def image_list( name )
   unless name == nil
    list = Array.new
    list << %Q{<script src="/javascripts/fotorama/jquery-1.10.2.min.js"></script>}
    list << %Q{<link href="/javascripts/fotorama/fotorama.css" rel="stylesheet">}
    list << %Q{<script src="/javascripts/fotorama/fotorama.js"></script>}
    list << %Q{<div class="fotorama" data-autoplay="3000" data-transition="dissolve" data-nav="thumbs" data-allow-full-screen="true" data-keyboard="true" data-width="640" data-height="480" data-thumb-width="64" data-thumb-height="48">} 
    dir = Dir.new( File.join(BASE_DIR, name) )
    dir.sort.each do | d |
      image = File.basename(d, File.extname(d))
      unless d =~ /^\./ || d =~ /thumbs/
        #list << %Q{<a href="/images/galleries/#{name}/#{d}" rel="shadowbox" title="#{image}"><img src="/images/galleries/#{name}/thumbs/#{d}" /></a>}
	list << %Q{<a href="/images/galleries/#{name}/#{d}"><img src="/images/galleries/#{name}/thumbs/#{d}"/></a>}
      end
    end
    list << %Q{</div> <!--class="fotorama" data-nav="thumbs" -->}
    #list.sort.join( "\n" )
  end
 end
end

Liquid::Template.register_filter(ImageList)
