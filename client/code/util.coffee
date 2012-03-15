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
