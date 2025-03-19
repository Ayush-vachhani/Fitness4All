/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_2340897058")

  // remove field
  collection.fields.removeById("date3021461029")

  // add field
  collection.fields.addAt(4, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3021461029",
    "max": 0,
    "min": 0,
    "name": "time_spent",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2340897058")

  // add field
  collection.fields.addAt(4, new Field({
    "hidden": false,
    "id": "date3021461029",
    "max": "",
    "min": "",
    "name": "time_spent",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "date"
  }))

  // remove field
  collection.fields.removeById("text3021461029")

  return app.save(collection)
})
