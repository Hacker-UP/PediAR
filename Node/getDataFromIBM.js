let fs = require('fs');
let request = require('request')
let imgUrl = './test1.jpg'
let [apiKey, formData] = ['972edf5591f140700b83472fd8b8fbb1184beed4', {'images_file': fs.createReadStream(imgUrl)}];

request.post({url:`https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=${apiKey}&version=2016-05-20`, formData: formData}, 
	function optionalCallback(err, httpResponse, body) {
  		if (err) {
  			//do sth...
    		console.log(err)
  		} else {
  			//do sth...

  			// sample
  			let dataObj = JSON.parse(body);
  			let classes = dataObj.images[0].classifiers[0].classes;
			console.log(
				classes.sort( (a, b) => (a.score < b.score ? 1 : -1) )
			)
  		}
	});


/*let request = require('request')

request.post({url:'http://10.1.0.85:8086', formData: {} }, function optionalCallback(err, httpResponse, body) {
	if (err) {
  			//do sth...
    		console.log(err)
  		} else {
  			//do sth...
  			console.log(body)
  		}
});*/