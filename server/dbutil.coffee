# DB util methods

#id: カウンタを区別する名前 1→2→3→・・・
exports.count=(id,cb)->
	M.counters (coll)->
		coll.findAndModify {id:id},{},{$inc:{number:1}},{}, (err,obj)->
			if err?
				throw err
			unless obj?
				# カウンタがないので作る
				coll.insert {id:id,number:2}
				cb 1
			else
				cb obj.number

#ObjectIDを使ったクエリ
exports.get_id=(str)->
	try
		new MongoDB.ObjectID str
	catch e
		null
