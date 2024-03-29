								#NIVEL 1

#Ejercicio 1 Mostra totes les transaccions realitzades per empreses d'Alemanya.

(SELECT * FROM transaction WHERE company_id IN          	#2º Busca las transacciones teniendo en cuenta el 1º filtro
	(SELECT id FROM company WHERE country = "Germany")) 	#1º filtra todas las empresas de Germany
;


/*Ejercicio 2 Màrqueting està preparant alguns informes de tancaments de gestió, 
 et demanen que els passis un llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.*/

(SELECT * FROM company WHERE company.id In 					#3º busca * datos de las compañias que cumplan 2º filtro
	(SELECT company_id  FROM transaction WHERE amount > 		 	#2º busca company_id sobre amount que sea mayor al 1º filtro
		(SELECT AVG(amount) FROM transaction WHERE declined = 0)	#1º busco la media de las ventas (declined=0 considerando solo ventas finalizadas). 
GROUP BY company_id)) 								#4º agrupo por company_id
;


/*Ejercicio 3 El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, 
 però no recorden el seu nom, només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions.*/ 

SELECT compañia.company_name, transaction.* FROM transaction  JOIN 							2ª selecciono en company_name del 1º filtro * de transaction para hacer una JOIN
	(SELECT id,company_name FROM company WHERE company_name LIKE "c%") AS compañia ON compañia.id = company_id	#1º busco las company_name que empiecen por "c%" y pongo un alias
; 

#Ejercicio 4 Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.

SELECT company_id FROM transaction WHERE company_id NOT IN 					#3º busca las company_id que no estén en el 2º filtro
	(SELECT company_id FROM 								#2º filtra las company_id que están en el 1º filtro
		(SELECT COUNT(id) FROM transaction GROUP BY company_id) AS count_transaction) 	#1º cuenta id de transacciones y agrupa por company_id
;


								#NIVEL 2

/*Ejercicio 1 En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia non institute. 
 Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.*/

(SELECT * FROM transaction  WHERE company_id IN 					#3º muestra lista de * transaction utilizando 2º filtro
	(SELECT id FROM company WHERE country IN  					#2º busca los id de company utilizando 1º filtro
		(SELECT country FROM company WHERE company_name = "non institute"))) 	#1º encuentra el country de Non Institue
 ;
 
 #Ejercicio 2  El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major suma en la base de dades.
 
 (SELECT * FROM company WHERE id IN 				#3º Muestro toda la informacion de company utilizando el 2º filtro
	(SELECT company_id FROM transaction WHERE amount IN 	#2º Busco el company_id que coincida con el 1º filtro
		(SELECT MAX(amount) FROM transaction) ))	#1º Busco el MAX(amount)
 ;
 
 
								#NIVEL 3
 
 /*Ejercicio 1 S'estan establint els objectius de l'empresa per al següent trimestre, 
  per la qual cosa necessiten una base sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. 
  Per a això, necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.*/

SELECT country, ROUND(AVG(amount),2) AS media_pais FROM company 						#2º selecciono country de company y media_pais de transaction
	JOIN transaction ON company.id = company_id WHERE declined = 0 GROUP BY country HAVING media_pais >  	# haciendo JOIN tomando solo declined=0 y agrupando por country haciendo Having para que me filtre las que sean mayores a la media general	
		(SELECT AVG(amount) FROM transaction As media_genral WHERE declined = 0 )			#1º busco la media general de transaction
 ;

/*Ejercico 2 Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
 per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent 
 i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.*/

SELECT id,company_name,phone,email,country,website,conteo,									#4º Finalmente le indico los datos que quiero mostrar a los que se agregará el CASE
CASE WHEN conteo > 4 THEN "Mas de 4 transacciones"										#3º con un CASE hago la condicion si conteo > 4 y asigno las respuestas
     WHEN conteo = 4 THEN "Justo 4 transacciones"										# Por si alguno tiene justo 4 transacciones
	ELSE "Menos de 4 transacciones"
END AS total_transacciones
 FROM
(SELECT * FROM company JOIN 													#2º hago JOIN con *company para tener los datos de las empresas
(SELECT company_id, COUNT(id) As conteo FROM transaction WHERE declined = 0 GROUP BY company_id) AS transacciones_finalizadas	#1º cuenta transacciones finalizadas por company_id
 ON company.id = company_id) AS d
 ;
