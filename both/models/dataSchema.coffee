#if Meteor.isServer
#  _ = Npm.require "underscore"
@dataSchema = (_objName, _addData) ->
  rslt = {}
  # add 될 데이터가 있다면 return 시에 extend 해서 반환한다.
  addData = _addData or {}
  createdAt = new Date()
  switch _objName
    when 'profile'
      rslt =
        name: ''


    when 'connection'
      rslt =
        createdAt: createdAt
        updatedAt: createdAt
        connectionInfo: null    #{}
    else
      throw new Error '### Data Schema Not found'

  return _.extend rslt, addData
