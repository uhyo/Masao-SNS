#option: {title:"",message:""}
exports._init=(option={},suburl,loader)->
	option.title ?= null
	option.message ?= null
	node=loader "special-message",option
	return end:->
