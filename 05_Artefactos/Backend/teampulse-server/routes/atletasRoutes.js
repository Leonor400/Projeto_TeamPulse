var express = require('express');
var router = express.Router();

var mAtletas = require("../models/atletasModel");

// GET /api/atletas
router.get("/", async function(req, res, next) {
    let atletas = await mAtletas.getAllAtletas();
    res.send(atletas);
});

// GET /api/atletas/:id
router.get("/:id", async function(req, res, next) {
    let id = req.params.id;
    let atleta = await mAtletas.getAtleta(id);
    res.send(atleta);
});

module.exports = router;
