Meteor.publish 'pub_customers', ->
  cl 'pub_customers'
  return CollectionCustomers.find()

Meteor.publish 'pub_results', ->
  cl 'pub_results'
  return CollectionResults.find()

Meteor.publish 'pub_voiceEMRs', (_customer_id) ->
  cl 'pub_voiceEMRs ' + _customer_id
  unless _customer_id then _customer_id = '1'
  return CollectionVoiceEMRs.find(customer_id: _customer_id)
