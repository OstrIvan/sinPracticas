(defglobal ?*nodo-gen* = 0);;para definir variables globales usamos el defglobal y para identificar las variables globales usamos *
(defglobal ?*profundidad* = 100)
(defglobal ?*contador* = 0)

(deffacts grid
	(Dimension 5 5)
	;;(Robot 1 1 bombilla 0 Farola farola 3 5 bombilla 2 farola 4 3 bombilla 3 farola 5 5 bombilla 2 Nivel 0)
	(Almacen almacen 2 3)
	(Robot 1 1 Bombilla 0 Nivel 0)
	(Farola 3 5 Bombilla 2)
	(Farola 4 3 Bombilla 3)
	(Farola 5 5 Bombilla 2)
)


(defrule subir
	(Dimension ?dx ?dy)
	(Robot ?rx ?ry Bombilla $?bombilla Nivel ?nivel)
	(Farola $?farola)
	(test (<= (+ ?ry 1) ?dy))
	(test (not (member$ (create$ farola ?rx (+ ?ry 1) Bombilla) $?farola))) ;;duda
	(test ( < ?nivel ?*profundidad*))
=>
	(assert (Robot ?rx (+ ?ry 1) Bombilla $?bombilla Nivel (+ ?nivel 1)))
	(bind ?*nodo-gen* (+ ?*nodo-gen* 1))
)



(defrule bajar
    (Dimension ?dx ?dy)
    (Robot ?rx ?ry Bombilla $?bombilla Nivel ?nivel)
    (test (>= (- ?ry 1) 1))
	(Farola $?farola)
    (test (not (member$ (create$ farola ?rx (- ?ry 1) Bombilla) $?farola)))
    (test ( < ?nivel ?*profundidad*))
=>
    (assert (Robot ?rx (- ?ry 1) Bombilla $?bombilla Nivel (+ ?nivel 1)))
    (bind ?*nodo-gen* (+ ?*nodo-gen* 1))
)



(defrule izquierda
    (Dimension ?dx ?dy)
    (Robot ?rx ?ry Bombilla $?bombilla Nivel ?nivel)
	(Farola $?farola)
    (test (>= (- ?rx 1) 1))
    (test (not (member$ (create$ farola (- ?rx 1) ?ry) $?farola)))
    (test ( < ?nivel ?*profundidad*))
=>
    (assert (Robot (- ?rx 1) ?ry Bombilla $?bombilla Nivel (+ ?nivel 1)))
    (bind ?*nodo-gen* (+ ?*nodo-gen* 1))
)



(defrule derecha
    (Dimension ?dx ?dy)
    (Robot ?rx ?ry Bombilla $?bombilla Nivel ?nivel)
	(Farola $?farola)
    (test (<= (+ ?rx 1) ?dx))
    (test (not (member$ (create$ farola (+ ?rx 1) ?ry) $?farola)))
    (test ( < ?nivel ?*profundidad*))
=>
    (assert (Robot (+ ?rx 1) ?ry Bombilla $?bombilla Nivel (+ ?nivel 1)))
    (bind ?*nodo-gen* (+ ?*nodo-gen* 1))
)



(defrule recoger
	(Dimension ?dx ?dy)
	(Robot ?rx ?ry Bombilla $?bombilla Nivel ?nivel)
	(Almacen $?almacen $?da $?db)
	(Bombilla $?bombilla)

	(test (or (< ?rx ?da) (> ?rx ?da) (< ?ry ?db) (> ?ry ?db)))
	(test (< ?bombilla 3))
=>
	(assert Robot ?rx ?ry Bombilla (+ ?bombilla 2) Nivel (+ ?nivel 1))
	(bind ?*nodo-gen* (+ ?*nodo-gen* 1))
)


git remote set-url origin https://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@github.com/OstrIvan/sinPracticas.git/
git remote add origin https://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@github.com/OstrIvan/sinPracticas.git/



























(defrule prof_max
	( declare (salience 10) )
	?f1 <- (R ?d $?a nivel ?n )
	(profundidad-maxima ?pm)
	(test (> ?n ?pm) )
=>
	(retract ?f1)
)


(defrule obj (declare (salience 100))
    (Robot ?rx ?ry Bombilla $?bombilla Nivel ?nivel)
    =>
	(printout t "Soluci�n encontrada en el nivel " ?nivel crlf)
	(printout t "N�mero de nodos expandidos o reglas disparadas " ?*nodo-gen* ?*profundidad* crlf)
	(halt)
)



(deffunction inicio ()
	(reset)
	(printout t "Profundidad Maxima:= " )
	(bind ?profundidad(read))
	(printout t "Tipo de Busqueda " crlf
		"1.-Anchura" crlf
		"2.-Profundidad" crlf )
	(bind ?a (read))
	(if (= ?a 1)
		then (set-strategy breadth)
		else (set-strategy depth)
		)
	(assert (profundidad-maxima ?*profundidad*))
		(run)
)

; (watch facts)
; (watch activations)
; (set-strategy breadth)
; (reset)
; (run)
; (exit)