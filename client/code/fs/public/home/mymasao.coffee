
exports._init=(option,suburl,loader)->
	app=require '/app'
	
	ss.rpc "users.myMasao", (docs)->
		if docs.error?
			#エラー
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:docs.error}
			return
		node=loader null,{masaos:docs}
		###
		ul=$ "#masaolist"
		docs.forEach (doc)->
			li=document.createElement "li"
			a=document.createElement "a"
			a.href="/masao/#{doc._id}"
			a.textContent=doc.title
			a.title=doc.description
			
			#設定リンク
			a2=document.createElement "a"
			a2.href="/manager/masao/#{doc.number}"
			a2.textContent="設定"
			
			ul.append $(li).append(a).append(document.createTextNode " ").append a2
		###
		
	return end:->
