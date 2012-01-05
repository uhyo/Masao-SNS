# Place your Database config here
mongodb=require 'mongodb'

#使用するコレクションを列挙しよう
collections=["users"]


config=SS.config.db.mongo	#/config/environments/development.coffee
global.MongoDB = new mongodb.Db config.name, new mongodb.Server config.host, config.port
MongoDB.open (err,client)->
  if err?
    console.log err
    throw err
  MongoDB.authenticate config.user, config.password, (err)->
    if err?
      console.log err
      throw err
    console.log "MongoDB Connection: success"
    global.M={}	#collectionへの簡易アクセス
    collections.forEach (x)->
      M[x]= (cb)->
        MongoDB.collection x,(err,col)->
          if err?
            console.log err
            throw err
          cb col
        

