
exports._init=(option,suburl,loader)->
	node=loader()
	app=require '/app'
	
	ss.rpc "users.myMasao", (docs)->
		console.log docs
		if docs.error?
			#エラー
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:docs.error}
			return
		ul=$ "#masaolist"
		docs.forEach (doc)->
			li=document.createElement "li"
			a=document.createElement "a"
			a.href="/masao/#{doc.number}"
			a.textContent=doc.title
			a.title=doc.description
			ul.append $(li).append a

		
	return end:->
