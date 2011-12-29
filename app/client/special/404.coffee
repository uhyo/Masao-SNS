exports.init=(option,suburl,loader)->
	node=loader "special-404",{url: suburl}
	return end:->
