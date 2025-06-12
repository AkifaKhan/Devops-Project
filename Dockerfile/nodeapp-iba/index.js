var express = require('express');
var app = express();

app.set('port', (process.env.PORT || 5000));
app.use(express.static(__dirname + '/public'));

// Route to handle the default page
app.get('/', function(request, response) {
  response.send('Hello World this app is deployed by Jenkins Crontab');
});

// Listen on all interfaces (0.0.0.0), not just localhost
app.listen(app.get('port'), '0.0.0.0', function() {
  console.log("Node app is running at localhost:" + app.get('port'));
});
