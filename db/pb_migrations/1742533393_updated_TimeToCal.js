/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_881336386")

  // update field
  collection.fields.addAt(4, new Field({
    "hidden": false,
    "id": "number627390209",
    "max": null,
    "min": null,
    "name": "gram_calorie",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_881336386")

  // update field
  collection.fields.addAt(4, new Field({
    "hidden": false,
    "id": "number627390209",
    "max": null,
    "min": null,
    "name": "calories",
    "onlyInt": false,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "number"
  }))

  return app.save(collection)
})
