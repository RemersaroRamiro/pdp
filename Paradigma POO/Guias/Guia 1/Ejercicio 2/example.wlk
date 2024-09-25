/*
Implementar en Wollok un objeto que represente a tom, que es un gato.
Lo que nos interesa de tom es manejar su energía y su velocidad, que dependen de sus actividades de comer ratones y de correr. 
La persona que registra las actividades de tom, registra los ratones que come y la cantidad de tiempo que corre en segundos. Cuando tom come un ratón,
 su energía aumenta en (12 joules + el peso del ratón en gramos). La velocidad de tom es 5 metros x segundo + (energia medida en joules / 10). 
Cuando tom corre, su energía disminuye en (0.5 x cantidad de metros que corrió). Observar que la cuenta está en joules consumidos por metro, pero cuando me 
dicen cuánto corrió, me lo dicen en segundos. La velocidad que se toma es la que corresponde a la energía de Tom antes de empezar a correr, y no varía durante una carrera.
Nota: además de tom, hay otros objetos en juego, ¿cuáles son, qué mensaje tienen que entender?
*/

object tom {
  var energia = 100
  method comerRaton(pesoDelRaton) {
    self.aumentarEnergia(12 + pesoDelRaton)
  }
  method aumentarEnergia(joules) {
    energia = energia + joules
  }
  method velocidad() {
    return 5 + energia/5
  }
  method correr(segundos) {
    self.disminuirEnergia(0.5* self.velocidad() * segundos)
  }
  method disminuirEnergia(joules) {
    energia = energia - joules
  }
}
