/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_881336386")

  // remove field
  collection.fields.removeById("number3658200307")

  // remove field
  collection.fields.removeById("number3665647835")

  // add field
  collection.fields.addAt(3, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3658200307",
    "max": 0,
    "min": 0,
    "name": "time_start",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(4, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3665647835",
    "max": 0,
    "min": 0,
    "name": "time_end",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_881336386")

  // add field
  collection.fields.addAt(1, new Field({
    "hidden": false,
    "id": "number3658200307",
    "max": null,
    "min": null,
    "name": "time_start",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  // add field
  collection.fields.addAt(2, new Field({
    "hidden": false,
    "id": "number3665647835",
    "max": null,
    "min": null,
    "name": "time_end",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  // remove field
  collection.fields.removeById("text3658200307")

  // remove field
  collection.fields.removeById("text3665647835")

  return app.save(collection)
})
