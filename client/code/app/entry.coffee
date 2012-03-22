# ssをグローバル変数として利用可能に
window.ss = require 'socketstream'

ss.server.on 'ready',->
  alert require
  alert require.modules
  #require '/app'
