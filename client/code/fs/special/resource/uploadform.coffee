# アップロードフォーム
#option.submit: 送信時に呼ばれる関数（引数：フォーム）
#option.requirefile: ファイルが必要かどうか
exports._init=(option={},suburl,loader)->
	node=loader "special-resource-uploadform"
	form=$(".resourceuploadform",node)
	preview=$(".resourcepreviewarea",node)
	
	util=require '/util'
	
	# プレビュー
	$("input[type=\"file\"]",form).attr("required",option.requirefile ? false).change (je)->
		form=je.target.form

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
	form.submit (je)->
		je.preventDefault()
		option.submit? je.target
		
	return {
		end:->
		setForm:(doc)->
			# resourcesに入っていたdocからフォーム入力
			for x in ["type","size","name","usage","comment"]
				form.get(0).elements[x].value=doc[x]
	}
			
