#option: {title:"",message:""}
exports._init=(option={},suburl,loader)->
	option.title ?= "エラー"
	option.message ?= null
	node=loader "special-error",option
	return end:->
