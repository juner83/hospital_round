// const streamer = new Meteor.Streamer('ep_sungmo');
//
// // if(Meteor.isClient) {
// //   streamer.on('message', function(message) {
// //     console.log('user: ' + message);
// //   });
// // }
// //
// if (Meteor.isServer) {
//   streamer.allowRead('all');
//   streamer.allowWrite('all');
//
//   sendMessage = function(message) {
//     streamer.emit('message', message);
//     console.log('me: ' + message);
//   };
//
// }