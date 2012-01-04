# Client-side Code

# Bind to socket events
#SS.socket.on 'disconnect', ->  $('#message').text('SocketStream server is down :-(')
#SS.socket.on 'reconnect', ->   $('#message').text('SocketStream server is up :-)')

# This method is called automatically when the websocket connection is established. Do not rename/delete
exports.init = ->
	# リンクを止める
	$(document).on 'click','a', (je)->
		return if je.isDefaultPrevented()
		href=je.target.href
		return unless href
		
		url=$.url href
		if url.attr("path")==location.pathname && url.attr("fragment")
			# ページ内移動だけ
			return
		
		je.preventDefault()
		
		history.pushState "","",href
		
		SS.client.app.startURL $("#contents"),href
	window.addEventListener 'popstate',(e)->
		SS.client.app.startURL $("#contents"),location.pathname

	SS.client.app.startURL $("#contents"),location.pathname
	#SS.client.app.startURL $("#contents"),"/login"


# プロセスをはじめる
# parent: プロセスを追加すべきnode
# processobj: SS.client.以下の何か
# template: デフォルトで読み込むべきテンプレート
exports.startProcess=(parent,processobj,template,suburl,option={})->
	return unless processobj?
	# プロセス側オブジェクトから一発で読み込むメソッドを用意してあげる
	# 返り血：トップのノード
	loader=(templatename,tmplopt)->
		# デフォルトのテンプレート
		templatename ?= template
		console.log "loaded: #{templatename}"
		topnode=$("##{templatename}").tmpl tmplopt
		$(parent).empty().append topnode
		topnode
		
	#オブジェクトを呼び出す
	controller=processobj.init option,suburl,loader
		
	
# URLからプロセスをはじめる
exports.startURL=(parent,url="/",option={})->
	origin="#{location.protocol}//#{location.host}"	#ex)http://localhost:3000
	if url.indexOf(origin)==0
		#プロトコルから始まる場合には /foo/bar 形式に修正
		url=url.slice origin.length
	#urlは /foo/bar形式
	current=SS.client.public	# app/client/public からURLに従って巡る
	directories=url.split("/")[1..]	# ["foo","bar"]
	templatename=["public"]	# templateのほうも探す（-で結ぶ）
	while directories.length>0
		dirname=directories[0]	#dirnameといっても一番最後はディレクトリじゃなくてリソース名
		if typeof current[dirname]=="object"
			# まだ奥に行ってもよさそうだ
			current=current[dirname]
			directories.splice 0,1
			templatename.push dirname
		else
			# ここで終了だ
			break
	if current==SS.client.public
		# トップページだった
		current=SS.client.special.top
	#残ったurlは　オブジェクトに渡す
	SS.client.app.startProcess parent,current,templatename?.join("-"),"/"+directories.join("/"),option
	
	
	
	
