module Jekyll
  class TagCloud < Liquid::Tag

    CLOUD_MAX_RANKS = 5;
    CLOUD_SIZE = 100;

    def render(context)
      s = StringIO.new
      begin
        tags = context['site']['tags']
        unless tags.nil?
          sorted = tags.sort {|a, b| b[1].length <=> a[1].length}
          factor = 1
          max_count = sorted[0][1].length
          min_count = sorted[-1][1].length

          if max_count == min_count
            min_count -= CLOUD_MAX_RANKS
          else
            factor = (CLOUD_MAX_RANKS - 1) / Math.log(max_count - min_count + 1)
          end

          if sorted.length < CLOUD_MAX_RANKS
            factor *= sorted.length / CLOUD_MAX_RANKS.to_f
          end

          for index in (0..CLOUD_SIZE).to_a.shuffle do
            if sorted[index].nil?
              next
            end

            dir = context['site']['tag_dir'] || 'tag'
            rank = CLOUD_MAX_RANKS - (Math.log(sorted[index][1].length - min_count + 1) * factor).to_i
            s << "<span class='rank-#{rank}'>"
            s << "<a href='/#{dir}/#{sorted[index][0]}'>#{sorted[index][0]}</a>"
            s << "</span> "
          end
        end
      rescue => boom
        # Nothing, I think
        p boom
      end
      s.string
    end
  end
end

Liquid::Template.register_tag('tag_cloud', Jekyll::TagCloud)
