class Plato {
  
    method calorias() = 3 * self.cantidad_azucar() + 100

    method cantidad_azucar()
    method es_bonito()
    method tiene_hasta_calorias(cantidad) = self.calorias() <= cantidad

    method ser_catado(catador) = catador.catar_plato(self)
}

class Entrada inherits Plato {
  
    override method cantidad_azucar() = 0
    override method es_bonito() = true

}

class Principal inherits Plato {
  
    var cantidad_azucar
    var esBonito
    override method cantidad_azucar() = cantidad_azucar
    override method es_bonito() = esBonito

}

class Postre inherits Plato {
    
    const cantidad_colores

    override method cantidad_azucar() = 120
    override method es_bonito() = cantidad_colores > 3

}
