#Masao loading module
exports.loadMasao=(masaoid,cb)->
	# masaoidが表す正男を読み込む
	query={}
	if /^\d+$/.test masaoid
		query.number=parseInt masaoid
	else if masaoid
		query._id=masaoid
	else
		cb {error:"正男IDが不正です"}
		return
	ss.rpc "masao.getMasao",query,cb
