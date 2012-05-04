# リソースを複数選択するフォーム
#option.submit: 送信時に呼ばれる関数（引数：フォーム）
#option.requirefile: ファイルが必要かどうか
exports._init=(option={},suburl,loader)->
	node=loader "special-resource-uploadform"
	form=$(".resourceuploadform",node).get 0
	preview=$(".resourcepreviewarea",node)
	
	util=require '/util'
	
	# プレビュー
	$("input[type=\"file\"]",form).attr("required",option.requirefile ? false).change (je)->

		# ファイルを取得
		file=form.elements["file"].files[0]
		return unless file?
		
		form.elements["name"].value=file.name
		form.elements["type"].value=file.type
		form.elements["size"].value=file.size
		
		# プレビュー
		p=preview.empty()
		if /^text\//.test file.type
			# テキストファイル
			reader=new FileReader()
			reader.onload=(e)->
				if reader.result.length>200
					# 200文字に短縮
					p.text "#{reader.result.slice 0,200}..."
				else
					p.text reader.result
			reader.readAsText file
		else if /^image\//.test file.type
			# 画像
			reader=new FileReader()
			reader.onload=(e)->
				img=util.previewImage reader.result
				p.append img
			reader.readAsDataURL file
	$(form).submit (je)->
		je.preventDefault()
		option.submit? je.target
		
	return {
		end:->
		setForm:(doc)->
			# resourcesに入っていたdocからフォーム入力
			for x in ["type","size","name","usage","comment"]
				form.elements[x].value=doc[x]
		requiresFile:(flg)->
			form.elements["file"].required=flg
		# base64 binaryをcbに渡す
		getFile:(cb)->
			file=form.elements["file"].files[0]
			unless file?
				cb null
				return
			
			reader=new FileReader()
			reader.onload=(e)->
				#reader.result:ArrayBuffer
				arr=new Uint8Array reader.result
				#arrにデータ
				string=Array.prototype.map.call(arr,(x)->String.fromCharCode x).join ""
				base64data=btoa string
				cb base64data
			reader.readAsArrayBuffer file


	}
			
