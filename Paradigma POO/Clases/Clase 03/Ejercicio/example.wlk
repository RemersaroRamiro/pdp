/*
Requisitos:
  - Vender entradas -> responsable: Una funcion
*/

class Asiento {
  var persona = ""
  method estaOcupado() {
    return persona != ""
  }
  method asignar(unaPersona) {
    persona = unaPersona
  }
}
class Funciones {
  var predio 
  var asientos = [new Asiento, new Asiento] 
  method venderEntrada(persona) {
    predio.asignarAsiento(persona)
  }
}
object teatro {
  var property capacidadCampo  
  method capacidadPlateaAlta() {}
  method capacidadPlateaBaja() {}
  method capacidadPlateaPreferencial() {}
}
object estadio {
  method capacidadPlateaAlta() {}
  method capacidadPlateaBaja() {}
  method capacidadPlateaPreferencial() {}
  method capacidadCampo() = 0
}