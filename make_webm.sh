ffmpeg -i your_gif.gif -c:v libvpx -crf 12 -b:v 500K output.webm

ffmpeg -i your_video.mkv -ss 00:00:10.000 -to 00:00:20.000 -c:v libvpx -crf 4 -b:v 1500K -vf scale=640:-1 -an output.webm


# Grab ffmpeg from https://www.ffmpeg.org/download.html

It's a command line tool which means you will have to type things with your keyboard instead of clicking on buttons.

The most trivial operation would be converting gifs:

ffmpeg -i your_gif.gif -c:v libvpx -crf 12 -b:v 500K output.webm


-crf values can go from 4 to 63. Lower values mean better quality.
-b:v is the maximum allowed bitrate. Higher means better quality.

To convert a part of a video file:

ffmpeg -i your_video.mkv -ss 00:00:10.000 -to 00:00:20.000 -c:v libvpx -crf 4 -b:v 1500K -vf scale=640:-1 -an output.webm



-ss is the start position in number of seconds, or in hh:mm:ss[.xxx] format. You can get it using your video player (Ctrl-G in MPC-HC).
-to is the end position.
-vf scale=640:-1 sets the width to 640px. The height will be calculated automatically according to the aspect ratio of the input.
-an disables audio. 4chan will reject your files if they contain audio streams.

Another encoding guide: https://trac.ffmpeg.org/wiki/vpxEncodingGuide
ffmpeg documentation: https://www.ffmpeg.org/ffmpeg.html

Current limits for WebM files on 4chan are:
Maximum file size is 3072KB.
Maximum duration is 120 seconds.
Maximum resolution is 2048x2048 pixels.
No audio streams.
