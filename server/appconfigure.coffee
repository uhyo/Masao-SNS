dbutil=require './dbutil.coffee'

# ssを使ったconfig
exports.configure=(ss)->
  # リソース読み込み
  ss.http.middleware.prepend (req,res,next)->
    if result=req.url.match /^\/resource\/(\w+)$/
      #リソースである
      M.resources (coll)->
        coll.findOne {_id:dbutil.get_id result[1]},(err,doc)->
          unless doc?
            # 404
            res.statusCode=404
            res.end "404 Not Found"
          else
            res.setHeader doc.type
            res.end doc.data.buffer
    else
      next()
