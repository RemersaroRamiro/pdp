object francoColapinto {
  var peso = 70 // referencia a otro objeto -> Todas las variables que sean 70 apuntan al mismo objeto
  // los numeros son objetos
  var auto = auto_williams
  method chamuyar() {
    return "Me contaron que sos muy divertida"
  }
  method correr(kilometrosCorridos) {
    peso = peso - kilometrosCorridos / 50  + auto.correr(kilometrosCorridos)
  }
  method peso() { // Getter : Me devuelve un atributo propio del objeto
    return peso
  }
  method auto(unAuto) { // Setter : Me cambia un atributo propio del objeto
    auto = unAuto
  }
}
object auto_williams {
  var nafta = 100
  method correr(kilometrosCorridos) {
    return (nafta - kilometrosCorridos / 7)
  }
}
object auto_ferrari {
  var nafta = 100
  var bateria = 100
  method correr(kilometrosCorridos) { // DELEGAR, SIEMPRE DELEGAR.
    self.gastar_nafta(kilometrosCorridos) // con self. mensaje se auto envia mensaje el objeto
    self.gastar_bateria(kilometrosCorridos)
  }
  method gastar_nafta(kilometrosCorridos) {
    nafta = nafta - kilometrosCorridos.min(100) / 7
  }
  method gastar_bateria(kilometrosCorridos) {
    if (kilometrosCorridos >= 100){
      bateria = bateria - (kilometrosCorridos - 100) / 7
    }
  }
} 
// Williams, ferrari y francoColapinto comparten interfaz -> Entienden los mismos mensajes. Sin embargo
// no cumplen polimorfismo porque para serlo necesitan de un tercero que los trate por igual. Como en el caso
// de Williams y ferrari con respecto a francoColapinto
// Ferrari y Williams son objetos distintos pero ambos son autos y se comportan igual , 
// pero no comparten el estado interno
// Objeto = Representacion de un ente computacional que exhibe comportamiento -> Mensajes que entiende
// No pensar en atributos -> Pensar en comportamiento
// Pilares de la POO: Encapsulamiento(Solo el mismo objeto le interesa sus atributos), Asignar responsabilidades y polimorfismo