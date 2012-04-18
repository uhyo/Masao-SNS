#HTML5 4.10.22.4 Constructing the form data set
exports.formQuery=(form)->
	result={}
	for el in form.elements
		continue if $(el).parents("datalist").length>0
		continue if el.disabled
		continue if el.type in ["button","reset"]
		continue if el.type in ["checkbox","radio"] && !el.checked
		continue unless el.name
		
		name=el.name
		value=el.value
		if el.type in ["button","reset"] && !value
			value="on"
		result[name]=value
	result
	
# 画像を縮小表示するやつ
exports.previewImage=(src,maxwidth=300,maxheight=300)->
	img=document.createElement "img"
	img.src=src
	img.addEventListener "load",(e)->
		w=img.naturalWidth
		h=img.naturalHeight
		if w>maxwidth || h>maxheight
			# 大きすぎると縮小する
			as=w/h
			zoom=1
			if as>=1
				# 横長
				zoom=maxwidth/w
			else
				# 縦長
				zoom=maxheight/h
			img.width=Math.floor w*zoom
			img.height=Math.floor h*zoom
		img.title="(#{w}×#{h})"
	img

