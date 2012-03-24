mongodb=require 'mongodb'

#使用するコレクションを列挙しよう
collections=["users"]


mc=config.mongo
global.MongoDB = new mongodb.Db mc.name, new mongodb.Server mc.host, mc.port
MongoDB.open (err,client)->
  if err?
    console.error err
    throw err
  MongoDB.authenticate mc.user, mc.password, (err)->
    if err?
      console.error err
      throw err
    console.log "MongoDB Connection: success"
    global.M={}	#collectionへの簡易アクセス
    collections.forEach (x)->
      M[x]= (cb)->
        MongoDB.collection x,(err,col)->
          if err?
            console.error err
            throw err
          cb col
        

