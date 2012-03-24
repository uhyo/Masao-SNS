// My SocketStream app

var http = require('http')
  , ss = require('socketstream');

ss.client.define('main', {
  view: 'app.jade',
  css:  ['libs', 'app.styl'],
  code: ['libs', 'app','fs'],
  tmpl:'*',
});

ss.http.router.on('/', function(req, res) {
  res.serve('main');
});

// Remove to use only plain .js, .html and .css files if you prefer
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-jade'));
ss.client.formatters.add(require('ss-stylus'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-clientjade'));

// Minimise and pack assets if you type  SS_ENV=production node app.js
if (ss.env == 'production') ss.client.packAssets();

var server = http.Server(ss.http.middleware);
server.listen(3000);

//config読み込み
global.config=require('./server/config.coffee');
//DB接続
require('./server/db.coffee');

ss.start(server);
