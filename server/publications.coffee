Meteor.publish 'pub_customers', () ->
  cl 'pub_customers'
  if Meteor.user()?.username?
    _doctor_id = Meteor.user().username
  else
    _doctor_id = '107027861'
  return CollectionCustomers.find({doctor_id: _doctor_id})

Meteor.publish 'pub_results', (_pid) ->
  cl 'pub_results'
  return CollectionResults.find(customer_id: _pid)

Meteor.publish 'pub_voiceEMRs', (_pid) ->
  cl 'pub_voiceEMRs ' + _pid
#  unless _customer_id then _customer_id = '1'
  return CollectionVoiceEMRs.find({customer_id: _pid}, {sort: {yymmdd: -1}, limit:5})

Meteor.publish 'pub_pacs', (_pid) ->
  cl 'pub_pacs'
  cl _pid
  return CollectionPacs.find(customer_id: _pid)

