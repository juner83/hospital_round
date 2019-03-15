Meteor.publish 'pub_customers', ->
  return CollectionCustomers.find()

Meteor.publish 'pub_results', ->
  cl 'pub_results'
  return CollectionResults.find()

