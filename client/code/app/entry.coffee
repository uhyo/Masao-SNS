# ssをグローバル変数として利用可能に
window.ss = require 'socketstream'

ss.server.on 'ready',->
  # 基本システムを開始
  require '/app'
