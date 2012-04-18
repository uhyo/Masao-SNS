#user util methods

# ユーザーデータをクライアント側に公開する形に修正
exports.publishFilter=(user)->
	delete user.password
	delete user.ip
	delete user.lasttime
