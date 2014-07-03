// WebcamJS v1.0
// Webcam library for capturing JPEG/PNG images in JavaScript
// Attempts getUserMedia, falls back to Flash
// Author: Joseph Huckaby: http://github.com/jhuckaby
// Based on JPEGCam: http://code.google.com/p/jpegcam/
// Copyright (c) 2012 Joseph Huckaby
// Licensed under the MIT License

/* Usage:
	<div id="my_camera" style="width:320px; height:240px;"></div>
	<div id="my_result"></div>
	
	<script language="JavaScript">
		Webcam.attach( '#my_camera' );
		
		function take_snapshot() {
			var data_uri = Webcam.snap();
			document.getElementById('my_result').innerHTML = 
				'<img src="'+data_uri+'"/>';
		}
	</script>
	
	<a href="javascript:void(take_snapshot())">Take Snapshot</a>
*/

