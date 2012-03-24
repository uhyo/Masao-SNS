#option: {title:"",message:""}
exports._init=(option,suburl,loader)->
	node=loader "special-error",option
	return end:->
