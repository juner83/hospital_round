Meteor.publish 'pub_customers', ->
  cl 'pub_customers'
  return CollectionCustomers.find({}, {limit: 8})

Meteor.publish 'pub_results', (_pid) ->
  cl 'pub_results'
  return CollectionResults.find(customer_id: _pid)

Meteor.publish 'pub_voiceEMRs', (_pid) ->
  cl 'pub_voiceEMRs ' + _pid
#  unless _customer_id then _customer_id = '1'
  return CollectionVoiceEMRs.find({customer_id: _pid}, {sort: {yymmdd: -1}, limit:5})


