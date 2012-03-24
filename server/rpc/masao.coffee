# Server-side Code

dbutil=require '../dbutil.coffee'

exports.actions = (req,res,ss)->

	# 正男オブジェクトをひとつ得る
	#query:{_id:"_id文字列"}または{number:数字}
	#エラー時: {error:"～"}
	getMasao:(query)->
		unless query?
			res {error:"クエリが不正です"}
			return
		M.masao (coll)->
			q={}
			if query.number
				q.number=query.number
			else if query._id
				# _idの文字列
				q._id=dbutil.get_id query._id
			coll.findOne q,(err,doc)->
				if err?
					throw err
				unless doc?
					res {error:"その正男は存在しません"}
				else
					res doc
	
# 正男の連番を得る
serveNewNumber=(cb)-> require('../dbutil').count "masaoNumber",cb
