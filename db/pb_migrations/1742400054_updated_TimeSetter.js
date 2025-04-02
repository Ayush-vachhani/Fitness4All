/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_92890578")

  // remove field
  collection.fields.removeById("text1872009285")

  // add field
  collection.fields.addAt(1, new Field({
    "hidden": false,
    "id": "number3483776891",
    "max": null,
    "min": null,
    "name": "Time",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_92890578")

  // add field
  collection.fields.addAt(1, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1872009285",
    "max": 0,
    "min": 0,
    "name": "time",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // remove field
  collection.fields.removeById("number3483776891")

  return app.save(collection)
})
