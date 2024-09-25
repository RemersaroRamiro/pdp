// Polimorfismo en POO: Que dos objetos entiendan el mismo mensaje y un tercero pueda mandar el mensaje sin importarte
// a quien se lo manda

// Sistema de venta de entradas para funciones
/* 
Colecciones: 
Listas: List []  
  - Esta indexada en base 0, tiene orden
  - Puede tener elementos repetidos
  - list.add(objeto) , list.remove(objeto) , list.get(indice) , list.anyOne() -> Devuelve un elemento random
  list.head()=list.first() 
Conjuntos: Sets #[]
  - No esta indexada, no tiene orden
  - No admite elementos repetidos.
  - No entiende mensajes de orden. El resto si
Con Lista.asSet() -> Devuelve a esa lista como un set, pero no modifica nada
*/
/*Clases , class: Molde para crear objetos QUE TIENEN IGUAL COMPORTAMIENTO
  - Hay que instanciarla -> var/const nombre = new Clase
*/

class Recital{
  var asientos = []
  method ventaDeEntrada(persona) {
    asientos.add(persona)
  }
  method entradasVendidas() {
    return asientos.size()
  }
  method asientosAsignadosConInicial(inicial) {
    return asientos.filter({nombre => nombre.startsWith() == inicial}) // Usando lambda, agarra el nombre (elemento de la lista) y le aplica X cosas
    /*
    "Funciones" para listas
    - map
    - forEach -> No devuelve nada
    - all
    - any
    */
  }
}
// "Lambdas" : Pedazo de codigo, var nombreLambda = {codigo} -> Sigue siendo objetos. clase de bloques Con nombreLambda.apply(parametros) lo aplico

