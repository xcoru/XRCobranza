'use strict';
const express = require('express');
const router = express.Router();

const path = require('path');
const pool = require(path.resolve('src/lib','database'));
const { access } = require('../../lib/security');
const { getShortDate } = require('../../lib/util');

//->>>>>    AGREGAR     --------------------------------------------------------------------
router.post('/', async (req, res) => {
    try {
        if (await access(req.body.hash, req.body.user)) {
            let r_d_solicitud = false;

            let rol = [req.body.rol];
            let info = [req.body.info];
            let fecha ="";

            if(info.fecha == null || info.fecha == ""){
                fecha = getShortDate();
            }else{
                fecha = info.fecha;
            }

            let datos = [];

            datos = await pool.query('CALL CLIENTES_NO_PAGO(?)', [fecha]);

            if (JSON.stringify(datos) != '[]') {
                r_d_solicitud = true;
            }
            let respuesta = {
                response: r_d_solicitud,
                session: true,
                solicitud: datos[0]
            };

            res.status(200).send(respuesta);

        } else {
            res.status(400).send({
                session: false
            });
        }
    } catch (e) {
        res.status(400).send({
            response: false,
            session: true,
            error: e
        });
    }
});

module.exports = router;