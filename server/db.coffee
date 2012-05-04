global.MongoDB=mongodb=require 'mongodb'

#使用するコレクションを列挙しよう
collections=["users","masao","counters","masaocomments","logs","resources","series"]

#CappedCollectionになるやつを列挙
cappeds=["logs"]


mc=config.mongo
global.MDB = new mongodb.Db mc.name, new mongodb.Server mc.host, mc.port
MDB.open (err,client)->
  if err?
    console.error err
    throw err
  MDB.authenticate mc.user, mc.password, (err)->
    if err?
      console.error err
      throw err
    console.log "MongoDB Connection: success"
    
    global.M={}	#collectionへの簡易アクセス
    collections.forEach (x)->
      M[x]= (cb)->
        MDB.collection x,(err,col)->
          if err?
            console.error err
            throw err
          cb col
    #capped Collection
    cappeds.forEach (x)->
      MDB.createCollection x,{capped:true,size:config.mongoCapped[x].size,max:config.mongoCapped[x].max},->

