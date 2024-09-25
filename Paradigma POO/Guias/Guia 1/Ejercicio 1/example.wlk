object pepita {
  var energia = 100
  var lugar = inicio
  method comer(gramos) {
    self.aumentarEnergia(4 * gramos)
  }
  method volar(kilometros) {
    self.disminuirEnergia(self.energiaPara(kilometros))
  }
  method aumentarEnergia(joules) {
    energia = energia + joules
  }
  method disminuirEnergia(joules) {
    energia = energia - joules
  }
  method irA(unLugar) {
    self.volar(unLugar.distancia(self))
    lugar = unLugar
  }
  method puedeIrA(unLugar) {
    return energia >= self.energiaPara(unLugar.distancia(self))
  }
  method energiaPara(kilometros) {
    return kilometros + 10
  }
  method kilometro() {
    return lugar.kilometro()
  }
}

object inicio {
  var property kilometro = 0
  method distancia(unPajaro) {
    return (unPajaro.kilometro() - kilometro).abs()
  }
}
object lugar_uno {
  var property kilometro = 10
  method distancia(unPajaro) {
    return (unPajaro.kilometro() - kilometro).abs()
  }
}
object lugar_dos {
  var property kilometro = 30
  method distancia(unPajaro) {
    return (unPajaro.kilometro() - kilometro).abs()
  }
}
object lugar_tres {
  var property kilometro = 45
  method distancia(unPajaro) {
    return (unPajaro.kilometro() - kilometro).abs()
  }
}
