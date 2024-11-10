import vikingo.*
class Soldado inherits Vikingo {

    var vidas_cobradas
    var armas

    override method es_productivo() = self.cobro_muchas_vidas() and self.esta_armado()

    method cobro_muchas_vidas() = vidas_cobradas >= 20

    method esta_armado() = armas > 0

    override method cobrarse_una_vida() {
        vidas_cobradas += 1
    }

    override method ganancia_social() {
        self.ganar_armas(10)
    }

    method ganar_armas(cantidad) {
        armas += cantidad
    }
}

class Granjero inherits Vikingo {

    var hectareas_propias
    var hijos

    override method es_productivo() = hectareas_propias >= 2*hijos

    override method ganancia_social() {
        self.tener_hijos(2)
        self.ganar_hectareas(2)
    }

    method tener_hijos(cantidad) {
        hijos += cantidad
    }
    method ganar_hectareas(cantidad) {
        hectareas_propias += cantidad
    }
}