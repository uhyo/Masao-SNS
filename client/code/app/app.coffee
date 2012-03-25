# Client-side Code

# Bind to socket events
#SS.socket.on 'disconnect', ->  $('#message').text('SocketStream server is down :-(')
#SS.socket.on 'reconnect', ->   $('#message').text('SocketStream server is up :-)')
# 外部用にIDを変更するアレ
userid=null	# 自分のユーザーIDを覚えておく（サーバー側でも覚えてるけど）
exports.setId=(id)->userid=id
exports.getId=->userid


# プロセスをはじめる
# parent: プロセスを追加すべきnode
# processobj: SS.client.以下の何か
# template: デフォルトで読み込むべきテンプレート
exports.startProcess=startProcess=(parent,processobj,template,suburl,option={})->
	return unless processobj?
	# プロセス側オブジェクトから一発で読み込むメソッドを用意してあげる
	# 返り血：トップのノード
	loader=(templatename,tmplopt)->
		# デフォルトのテンプレート
		templatename ?= template
		topnode=$ (JT[templatename] ? JT["#{templatename}-index"]) tmplopt
		$(parent).empty().append topnode
		topnode.get 0
	loader.parent=parent	# 親も教えてあげる（読み込まないとき用）
	controller = {}	# ユーティリティを提供する
	loader.controller=controller
	
	# URLフィルタ（自分のところだけで解決。ドメインなどは取り除く）
	controller.urlFilter=(regexp,func)->
		$(parent).on "click","a", (je)->
			return if je.isDefaultPrevented()
			href=je.target.href
			return unless href
			url=$.url href
			if url.attr("host")!=location.hostname || url.attr("port")!=location.port
				# 外部へ
				return
			# マッチするかどうか
			result=url.attr("path").match regexp
			if result?
				je.preventDefault()
				if func?
					# 関数があるなら呼び出す
					func result
				else
					# ないなら移動する
					startURL parent,href
	
		
	#オブジェクトを呼び出す
	controller.cont=processobj._init option,suburl,loader
	
	return controller
		
	
# URLからプロセスをはじめる
# startURLで処理されるオプション:_nohistory:true
exports.startURL=startURL=(parent,url="/",option={})->
	origin="#{location.protocol}//#{location.host}"	#ex)http://localhost:3000
	if url.indexOf(origin)==0
		#プロトコルから始まる場合には /foo/bar 形式に修正
		url=url.slice origin.length
	console.log parent
	if $(parent).attr("id")=="contents" && !option._nohistory
		# 全体的に移動する場合は履歴いじる
		history.pushState "","",url

	#urlは /foo/bar形式
	directories=url.split("/")[1..]	# ["foo","bar"]
	# 上から順番に
	templatename=[]	# templateのほうも探す（-で結ぶ）
	gone=[]	# ダメだったやつ
	while directories.length>0
		dirname=directories[0]	#dirnameといっても一番最後はディレクトリじゃなくてリソース名
		flag=false
		try
			require.resolve "/public/#{directories.join '/'}"
			# no error
			templatename=["public"].concat directories
			break
		catch e
			# no module
			gone.unshift directories.pop()

	current=null	# ページオブジェクト
	if templatename.length==0
		# トップページだった
		current=require '/special/top'	# トップページ
	else
		current=require "/#{templatename.join '/'}"
	###
	while !current._init && current.index
		current=current.index
		templatename.push "index"
	###
	#残ったurlは　オブジェクトに渡す
	return startProcess parent,current,templatename?.join("-"),"/"+gone.join("/"),option

# エラーページを表示する
exports.error=(parent,option)->
	startProcess parent,require('/special/error'),null,null,option
# メッセージを表示する
exports.message=(parent,option)->
	startProcess parent,require('/special/message'),null,null,option
# ログインしていない場合はログインさせる
# parent:ログインフォーム表示場所 message:表示するメッセージ（省略可）
exports.assertLogin=(opts...,cb)->
	[parent,message]=opts
	message ?= "ログインして下さい"
	unless userid?
		# まだログインしていない
		startURL parent,"/login", {_nohistory:true,to:cb,message:message}
	else
		# ログイン済み
		cb()
	
#============== main code start
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
	
	startURL $("#contents"),href
window.addEventListener 'popstate',(e)->
	startURL $("#contents"),location.pathname

startURL $("#contents"),location.pathname


	
	
