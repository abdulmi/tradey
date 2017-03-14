var settings = require('./settings')
var AWS = require('aws-sdk')
var AWS_config_option = {
  region: settings.DB_REGION,
  endpoint: settings.DB_ENDPOINT
}
AWS.config.update(AWS_config_option);
var db = new AWS.DynamoDB();
var itemTable = "items"
var requestsTable = "requests"
var usersTable = "users"

//creating Items table

//generating "uuid" from stackoverflow
// 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
//     var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
//     return v.toString(16);
// });


// creating tables
// var paramsItems = {
//   TableName: itemTable,
//   AttributeDefinitions: [
//     {
//       AttributeName: 'id',
//       AttributeType: 'S'
//     },
//     {
//       AttributeName: 'userId',
//       AttributeType: 'S'
//     },
//     {
//       AttributeName: 'category',
//       AttributeType: 'S'
//     }
//   ],
//   KeySchema: [
//     {
//       AttributeName: 'id',
//       KeyType: 'HASH'
//     }
//   ],
//   ProvisionedThroughput: {
//     ReadCapacityUnits: 1,
//     WriteCapacityUnits: 1
//   },
//   GlobalSecondaryIndexes: [
//     {
//       IndexName: 'grabByUser',
//       KeySchema: [
//         {
//           AttributeName: 'userId',
//           KeyType: 'HASH'
//         },
//       ],
//       Projection: { ProjectionType: 'ALL'},
//       ProvisionedThroughput: {
//         ReadCapacityUnits: 1,
//         WriteCapacityUnits: 1
//       }
//     },
//     {
//       IndexName: 'grabByCategory',
//       KeySchema: [
//         {
//           AttributeName: 'category',
//           KeyType: 'HASH'
//         },
//       ],
//       Projection: { ProjectionType: 'ALL'},
//       ProvisionedThroughput: {
//         ReadCapacityUnits: 1,
//         WriteCapacityUnits: 1
//       }
//     },
//     /* more items */
//   ],
// }
//
// db.createTable(paramsItems, function(err, data) {
//   if (err) console.log(err, err.stack); // an error occurred
//   else     console.log(data);           // successful response
// });
//

// var paramsRequests = {
//   TableName: requestsTable,
//   AttributeDefinitions: [
//     {
//       AttributeName: 'id',
//       AttributeType: 'S'
//     },
//     {
//       AttributeName: 'fromUserId',
//       AttributeType: 'S'
//     },
//     {
//       AttributeName: 'toUserId',
//       AttributeType: 'S'
//     },
//     {
//       AttributeName: 'fromItemId',
//       AttributeType: 'S'
//     },
//     {
//       AttributeName: 'toItemId',
//       AttributeType: 'S'
//     },
//   ],
//   KeySchema: [
//     {
//       AttributeName: 'id',
//       KeyType: 'HASH'
//     }
//   ],
//   ProvisionedThroughput: {
//     ReadCapacityUnits: 1,
//     WriteCapacityUnits: 1
//   },
//   GlobalSecondaryIndexes: [
//     {
//       IndexName: 'grabByToUser',
//       KeySchema: [
//         {
//           AttributeName: 'toUserId',
//           KeyType: 'HASH'
//         },
//       ],
//       Projection: { ProjectionType: 'ALL'},
//       ProvisionedThroughput: {
//         ReadCapacityUnits: 1,
//         WriteCapacityUnits: 1
//       }
//     },
//     {
//       IndexName: 'grabByFromUser',
//       KeySchema: [
//         {
//           AttributeName: 'fromUserId',
//           KeyType: 'HASH'
//         },
//       ],
//       Projection: { ProjectionType: 'ALL'},
//       ProvisionedThroughput: {
//         ReadCapacityUnits: 1,
//         WriteCapacityUnits: 1
//       }
//     },
//     {
//       IndexName: 'grabByFromItem',
//       KeySchema: [
//         {
//           AttributeName: 'fromItemId',
//           KeyType: 'HASH'
//         },
//       ],
//       Projection: { ProjectionType: 'ALL'},
//       ProvisionedThroughput: {
//         ReadCapacityUnits: 1,
//         WriteCapacityUnits: 1
//       }
//     },
//     {
//       IndexName: 'grabByToItem',
//       KeySchema: [
//         {
//           AttributeName: 'toItemId',
//           KeyType: 'HASH'
//         },
//       ],
//       Projection: { ProjectionType: 'ALL'},
//       ProvisionedThroughput: {
//         ReadCapacityUnits: 1,
//         WriteCapacityUnits: 1
//       }
//     },
//     /* more items */
//   ],
// }
//
// db.createTable(paramsRequests, function(err, data) {
//   if (err) console.log(err, err.stack); // an error occurred
//   else     console.log(data);           // successful response
// });
//
// var paramsUsers = {
//   TableName: usersTable,
//   AttributeDefinitions: [
//     {
//       AttributeName: 'id',
//       AttributeType: 'S'
//     },
//   ],
//   KeySchema: [
//     {
//       AttributeName: 'id',
//       KeyType: 'HASH'
//     }
//   ],
//   ProvisionedThroughput: {
//     ReadCapacityUnits: 1,
//     WriteCapacityUnits: 1
//   },
// }
//
// db.createTable(paramsUsers, function(err, data) {
//   if (err) console.log(err, err.stack); // an error occurred
//   else     console.log(data);           // successful response
// });

function tableExists(name) {
  var params = {
    TableName: name
  }
  db.describeTable(params,(err,res)=>{
    if(err) return false
    return true
  })
}

function getItemsFromTable(name,callback) {
  var params = {
    TableName: name
  }
  db.scan(params,(err,res)=>{
    if(err) {
      console.log(err)
      callback(false)
    } else {
      console.log(res)
      callback(res["Items"])
    }
  })
}

function createItem(category,userId,description,imageUrl,title,callback){
  var params = {
    TableName: itemTable,
    ReturnValues: 'ALL_OLD',
    Item: {
      "id" : {
          S: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
              var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
              return v.toString(16);
          })
      },
      "category": {
          S: category
      },
      "description": {
          S: description
      },
      "imageUrl": {
          S: imageUrl
      },
      "timestamp": {
          S: (new Date()).toTimeString()
      },
      "title": {
          S: title
      },
      "userId": {
          S: userId
      }
    }
  }
  db.putItem(params,(err,res)=>{
    if(err) {
      console.log(err)
      callback(false)
    } else {
      callback(res)
    }

  })
}

function createUser(id,phoneNumber,callback) {
  var params = {
    TableName: usersTable,
    Item: {
      "id": {
          S: id
      },
      "phone": {
          S: phoneNumber
      }
    }
  }
  db.putItem(params,(err,res)=>{
    if(err) {
      console.log(err)
      callback(false)
    }
    else {
      callback(res)
    }
  })
}

function getItemById(tablename,id,callback) {
  var params = {
    TableName: tablename,
    Key: {
      "id": {
          S: id
      }
    }
  }
  db.getItem(params,(err,res)=>{
    if(err) {
      console.log(err)
      callback(false)
    } else {
      callback(res)
    }
  })
}

function getItemsByCategory(cat,callback) {
  var params = {
    TableName: itemTable,
    IndexName: 'grabByCategory',
    KeyConditionExpression: "category = :cat",
    ExpressionAttributeValues: {
        ":cat": {
            S: cat
        }
    }
  }
  db.query(params,(err,res)=>{
    if(err) {
      console.log(err)
      callback(false)
    } else {
      callback(res["Items"])
    }
  })
}

function getItemsByUser(uId,callback) {
  var params = {
    TableName: itemTable,
    IndexName: 'grabByUser',
    KeyConditionExpression: "userId = :uId",
    ExpressionAttributeValues: {
        ":uId": {
            S: uId
        }
    }
  }
  db.query(params,(err,res)=>{
    if(err) callback(false)
    else {
      callback(res["Items"])
    }
  })
}

//returns true if accepted and false if pending request
function isAccepted(value) {
  return value["accepted"]
}

function isPending(value) {
  return !value["accepted"]
}

function getAcceptedRequestsForUser(id,callback) {
  var paramsFrom = {
    TableName: requestsTable,
    IndexName: "grabByFromUser",
    KeyConditionExpression: "fromUserId = :fromId",
    ExpressionAttributeValues: {
        ":fromId": {
            S: id
        }
    }
  }
  var paramsTo = {
    TableName: requestsTable,
    IndexName: "grabByToUser",
    KeyConditionExpression: "toUserId = :toId",
    ExpressionAttributeValues: {
        ":toId": {
            S: id
        }
    }
  }
  db.query(paramsFrom,(err,res)=>{
    if(err) callback(false)
    else {
      db.query(paramsTo,(errsec,ressec)=>{
        if(errsec) callback(false)
        else {
          callback({
            "acceptedFromUser": res["Items"].filter(isAccepted),
            "acceptedToUser": ressec["Items"].filter(isAccepted)
          })
        }
      })
    }
  })
}

function getPendingRequestsForUser(toId,callback) {
  var params = {
    TableName: requestsTable,
    IndexName: "grabByToUser",
    KeyConditionExpression: "toUserId = :toId",
    ExpressionAttributeValues: {
        ":toId": {
            S: toId
        }
    }
  }
  db.query(params,(err,res)=>{
    if(err) {
      callback(false)
    }
    else {
      callback({"pendingtoUser": res["Items"].filter(isPending)})
    }
  })
}

function AcceptRequest(id,callback) {
  var params = {
    TableName: requestsTable,
    Key: {
      "id": {
          S: id
      }
    },
    UpdateExpression: "SET #accepted = :status",
    ExpressionAttributeNames: {
      "#accepted": "accepted"
    },
    ExpressionAttributeValues: {
      ":status" : {
          S: "true"
      }
    }
  }
  db.updateItem(params,(err,res)=>{
    if(err) callback(false)
    else {
      callback(res)
    }
  })
}

function DeclineRequest(id,callback) {
  var params = {
    TableName: requestsTable,
    Key: {
      "id": {
          S: id
      }
    },
    UpdateExpression: "SET #accepted = :status",
    ExpressionAttributeNames: {
      "#accepted": "accepted"
    },
    ExpressionAttributeValues: {
      ":status" : {
          S: "false"
      }
    }
  }
  db.updateItem(params,(err,res)=>{
    if(err) callback(false)
    else {
      callback(res)
    }
  })
}

function sendRequest(fromUserId,toUserId,toItemId,fromItemId,callback) {
  var params = {
    TableName: requestsTable,
    Item: {
      "id": {
          S: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
              var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
              return v.toString(16);
          })
      },
      "fromUserId": {
          S: fromUserId
      },
      "toUserId": {
          S: toUserId
      },
      "fromItemId": {
          S: fromItemId
      },
      "toItemId": {
          S: toItemId
      }
    }
  }
  db.putItem(params,(err,res)=>{
    if(err) callback(false)
    else {
      callback(true)
    }
  })
}

//returns bool and request status if(bool)
function isrequestedBetweenItems(id_1,id_2,callback) {
  var params = {
    TableName: requestsTable,
    IndexName: "grabByToItem",
    KeyConditionExpression: "toItemId = :toId",
    ExpressionAttributeValues: {
        ":toId": {
            S: id_1
        }
    }
  }
  var paramsFromUser ={
    TableName: requestsTable,
    IndexName: "grabByFromItem",
    KeyConditionExpression: "fromItemId = :fromId",
    ExpressionAttributeValues: {
        ":fromId": {
            S: id_1
        }
    }
  }
  db.query(params,(err,res)=>{
    if(err) {
      console.log(err)
      callback(false)
    }
    else{
      for (var item of res["Items"]) {
        if(item.fromItemId.S === id_2) {
          console.log("ACCEPTED")
          callback(item)
          return
        }
      }
      db.query(paramsFromUser,(err_1,res_1)=>{
        if(err_1) {
          console.log(err_1)
          callback(false)
        } else {
          for (var item of res_1["Items"]) {
            if(item.toItemId.S == id_2) {
              console.log("ACCEPTED")
              callback(item)
              return
            }
          }
        }
        callback(false)
      })
    }
  })
}

// function getPhoneByItemId(id,callback) {
//   var params = {
//     TableName: usersTable,
//     Key: {
//       "id": {
//           S: id
//       }
//     }
//   }
//   db.getItem(params,(err,res)=>{
//     if(err) callback(false)
//     callback(res)
//   })
// }


module.exports = {
  tableExists: tableExists,
  getItemsFromTable: getItemsFromTable,
  createItem: createItem,
  createUser: createUser,
  getItemById: getItemById,
  getItemsByCategory: getItemsByCategory,
  getItemsByUser: getItemsByUser,
  isAccepted: isAccepted,
  isPending: isPending,
  getAcceptedRequestsForUser: getAcceptedRequestsForUser,
  getPendingRequestsForUser: getPendingRequestsForUser,
  AcceptRequest: AcceptRequest,
  DeclineRequest: DeclineRequest,
  sendRequest: sendRequest,
  isrequestedBetweenItems: isrequestedBetweenItems
}
