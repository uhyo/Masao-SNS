# リソース選択フィールド（あえてformは使ってないかも）
#option.user_id: 初期値
#option.resourcesObject
#option.title: タイトル
exports._init=(option={},suburl,loader)->
	node=loader "special-resource-chooseresource", {title:option.title}
	resources=$(".resourcesarea",form)
	selectarea=$(".selectarea",form)
	
	app=require '/app'
	util=require '/util'
	
	# 編集中のオブジェクト
	resourcesObject={}
	
	form={}
	for x in ["resourcefindbutton","resourceusage","resourceusageeq","resourceuserid","resourcefindbutton"]
		form[x]=$("[name=\"#{x}\"]",node).get 0
	
	# リソース選択
	$(form.resourcefindbutton).click (je)->
		opt=
			user_id:form.resourceuserid.value
			usage:form.resourceusage.value
			select:(resource)->
				# 選ばれたら呼ばれる
				usage=form.resourceusage.value || resource.usage
				unless usage
					return
				resources.find(".resourcebox").filter((idx)->@dataset.usage==usage).remove()
				resourcesObject[usage]=resource._id
				resources.append getResourceBox resource,usage
				
				
		unless form.resourceusageeq.checked
			delete opt.usage
		
		app.startURL selectarea,"/resourcelist",opt
	
	if option.user_id
		form.resourceuserid.value=option.user_id
	if option.resourcesObject
		# 初期値
		resourcesObject=JSON.parse JSON.stringify option.resourcesObject
		initresource resources, resourcesObject
	return {
		end:->
		setResources:(obj)->
			resourcesObject=JSON.parse JSON.stringify obj
			initresource  resources, resourcesObject
		getResources:->
			JSON.parse JSON.stringify resourcesObject

	}
	
initresource=(resources,obj)->
	# リソースをアレする
	resources.empty()
	ids=[]
	for name,value of obj
		ids.push value
	# 全部取得する
	if ids.length>0
		ss.rpc "resource.getResource",{_id:ids},(docs)->
			for name,value of obj
				for x in docs
					if x._id==value
						resources.append getResourceBox x,name

# resourcebox @return jQuery
getResourceBox=(resource,usage)->
	result=$ JT["tmp-resourcebox"] {resource:resource}
	result.prop("dataset").usage=usage
	result
			
