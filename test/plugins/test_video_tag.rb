describe "Jekyll::VideoTag" do
  before(:all) do
    require './plugins_helper.rb'

    include Liquid
    require "#{OCTOPRESS_ROOT}plugins/video_tag.rb"
  end

  it "should return video tag" do
    video1 = Jekyll::VideoTag.new('video', 'http://site.com/video.mp4', [])
    video1.render(nil).should eql(
      "<video width='' height='' preload='none' controls poster=''>" +
      "<source src='http://site.com/video.mp4' type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'/></video>"
    )

    video2 = Jekyll::VideoTag.new('video', 'http://site.com/video.mp4 720', [])
    video2.render(nil).should eql(
      "<video width='' height='' preload='none' controls poster=''>" +
      "<source src='http://site.com/video.mp4' type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'/></video>"
    )

    video3 = Jekyll::VideoTag.new('video', 'http://site.com/video.mp4 720 480', [])
    video3.render(nil).should eql(
      "<video width='720' height='480' preload='none' controls poster=''>" +
      "<source src='http://site.com/video.mp4' type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'/></video>"
    )

    video4 = Jekyll::VideoTag.new('video', 'http://site.com/video.mp4 720 480 http://site.com/poster-frame.jpg', [])
    video4.render(nil).should eql(
      "<video width='720' height='480' preload='none' controls poster='http://site.com/poster-frame.jpg'>" +
      "<source src='http://site.com/video.mp4' type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'/></video>"
    )
  end
end
