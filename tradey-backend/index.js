var app = require('express')()
var db = require('./db.js')
var bodyParser = require('body-parser')
app.use( bodyParser.json() );       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
}));

app.post('/tradey/v1/item',(req,res)=>{
    db.createItem(
      category=req.body.category,
      userId=req.body.userId,
      description=req.body.description,
      imageUrl=req.body.imageUrl,
      title=req.body.title,
      function(err_1,res_1){
          if(err_1){
            console.log(err_1)
            res.send(err_1)
          } else{
            if (!res_1) {
              console.log("err, got back false, couldn't createitem")
              res.send("err, got back false, couldn't createitem")
            } else {
              res.send(res_1)
            }
          }
      }
    )
})

app.get('/tradey/v1/item/id/:id',(req,res)=>{
    db.getItemById("items",req.params.id,function(err,item){
      if(err) {
        console.log(err)
        res.send(err)
      }
      else {
        res.send(item)
      }
    })
})

app.post('/tradey/v1/user',(req,res)=>{
  db.createUser(id=req.body.id,phoneNumber=req.body.phoneNumber,function(err,user){
      if(err){
        console.log(err)
        res.send(err)
      }else {
        res.send(user)
      }
  })
})

app.get('/tradey/v1/item/category/:cat',(req,res)=>{
  db.getItemsByCategory(cat=req.params.cat,function(err,items){
      if(err){
        console.log(err)
        res.send(err)
      }else {
        res.send(items)
      }
  })
})

app.get('/tradey/v1/item/user/:user',(req,res)=>{
  db.getItemsByUser(uId=req.params.user,function(err,items){
      if(err){
        console.log(err)
        res.send(err)
      }else{
        res.send(items)
      }
  })
})

app.get('/tradey/v1/request/accepted/:id',(req,res)=>{
  db.getAcceptedRequestsForUser(id=req.params.id,function(err,requests){
      if(err){
        console.log(err)
        res.send(err)
      }else {
        res.send(requests)
      }
  })
})

app.get('/tradey/v1/request/pending/:toId',(req,res)=>{
  db.getPendingRequestsForUser(toId=req.params.toId,function(err,requests){
      if(err){
        console.log(err)
        res.send(err)
      }else {
        res.send(requests)
      }
  })
})

app.post('/tradey/v1/request/accept',(req,res)=>{
  db.AcceptRequest(id=req.body.id,function(err,requests){
      if(err){
        console.log(err)
        res.send(err)
      }else {
        res.send(requests)
      }
  })
})

app.post('/tradey/v1/request/decline',(req,res)=>{
  db.DeclineRequest(id=req.body.id,function(err,requests){
      if(err){
        console.log(err)
        res.send(err)
      }else {
        res.send(requests)
      }
  })
})

app.post('/tradey/v1/request/send',(req,res)=>{
  db.sendRequest(fromUserId=req.body.fromUserId,
                  toUserId=req.body.toUserId,
                  toItemId=req.body.toItemId,
                  fromItemId=req.body.fromItemId,function(err,request){
                    if(err){
                      console.log(err)
                      res.send(err)
                    }else {
                      res.send(request)
                    }
                  })
})

app.get('/tradey/v1/request/valid/:id_1/:id_2',(req,res)=>{
  db.isrequestedBetweenItems(id_1=req.params.id_1,
                            id_2=req.params.id_2,function(err,request){
                              if(err){
                                console.log(err)
                                res.send(err)
                              }else {
                                res.send(request)
                              }
                            })
})

app.get('/tradey/v1/items',(req,res)=>{
    db.getItemsFromTable("items",function(err,items){
      if(err) {
        console.log(err)
        res.send(err)
      }
      else {
        res.send(items)
      }
    })
})

app.get('/tradey/v1/requests',(req,res)=>{
    db.getItemsFromTable("requests",function(err,requests){
      if(err){
          console.log(err)
          res.send(err)
      }else {
          res.send(requests)
      }
    })
})

app.listen(3000, function () {
  console.log('Example app listening on port 3000!')
})
