#option: {title:"",message:""}
exports._init=(option,suburl,loader)->
	node=loader "special-message",option
	return end:->
