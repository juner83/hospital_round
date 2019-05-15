@Images = new FilesCollection
  collectionName: 'images'
  allowClientCode: false
  onBeforeUpload: (file)->
    if file.size <= 10245760 and /png|jpg|jpeg|svg/i.test file.extension then return true
    else return '10MB 크기 이하의 png, jpg, jpeg, svg 형식의 이미지만 가능합니다.'
  interceptDownload: (http, image, versionName)->
# Serve file from GridFS
    _id = (image.versions[versionName].meta || {}).gridFsFileId
    if _id
      readStream = gfs.createReadStream _id
      readStream.on 'error', (err) -> throw err
      readStream.pipe http.response
    return Boolean(_id) # Serve file from either GridFS or FS if it wasn't uploaded yet
  onAfterRemove: (images)->
# Remove corresponding file from GridFS
    images.forEach (image)->
      Object.keys(image.versions).forEach (versionName)->
        _id = (image.versions[versionName].meta || {}).gridFsFileId
        if _id then gfs.remove _id, (err)-> if err then throw err