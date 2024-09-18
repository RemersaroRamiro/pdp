/*
Ejercicio 1 - Pepita básica
Pepita ahora es mensajera, le enseñamos a volar sobre la ruta 9.
Agregar los siguientes lugares sobre la ruta 9, con el kilómetro en el que está cada una, y agregar lo que haga falta para que:
pepita sepa dónde está (vale indicarle un lugar inicial al inicializarla).
le pueda decir a pepita que vaya a un lugar, eso cambia el lugar y la hace volar la distancia.
pueda preguntar si pepita puede o no ir a un lugar, puede ir si le da la energía para hacer la distancia entre donde está y donde le piden ir.
Por ahora no validamos cuando le pedimos que vaya que pueda ir, eso lo agregaremos más adelante.
Pensar en particular
qué objeto se debe encargar del cálculo de la distancia entre dos lugares, piensen cómo lo preguntarían desde la consola. 
Si resulta que el cálculo se repite para distintos objetos… OK, después vamos a ver cómo arreglar eso.
cómo hago para no repetir en distintos métodos de pepita la cuenta de la energía que necesita para moverse una cantidad de kilómetros.
*/

object pepita {
  var energia = 100
  method comer(gramos) {
    energia += 4 * gramos
  }
  method volar(kilometros) {
    energia -= 10 + kilometros
  }
}