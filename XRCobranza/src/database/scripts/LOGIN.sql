DROP PROCEDURE IF EXISTS LOGIN;
 DELIMITER //
CREATE PROCEDURE LOGIN(IN usuario VARCHAR(50), IN pass VARCHAR(100))
	BEGIN
		SELECT 
			u.id_usuario, 
			CONCAT_WS(" ", p.nombre, p.apellido_paterno) AS "nombre", 
			u.id_rol, 
			u.id_ruta, 
			u.id_empresa, 
			u.id_sucursal, 
			c.id_moneda, 
			c.id_zona_horaria
		FROM usuario u
		LEFT JOIN persona AS p ON u.id_persona = p.id_persona
		LEFT JOIN empresa AS e ON e.id_empresa = u.id_empresa
		LEFT JOIN sucursal AS s ON s.id_sucursal = u.id_sucursal
		LEFT JOIN configuracion AS c ON u.id_empresa = c.id_empresa

		WHERE u.usuario = usuario AND u.password = pass 
		AND (u.id_estado = 1 AND p.id_estado = 1 AND e.id_estado = 1 
		AND (s.id_estado = 1 OR u.id_rol = 1) AND c.licencia_fin >= CURDATE() OR u.id_rol = 4);
	END //
DELIMITER ;