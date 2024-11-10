class Expedicion {

    var tripulacion = []
    var lugares_involucrados = #{}

    method subir_a(unVikingo) {
        tripulacion.add(unVikingo)
    }

    method vale_la_pena() = self.lugares_involucrados_valen_la_pena() 

    method lugares_involucrados_valen_la_pena() = lugares_involucrados.all { lugar => lugar.vale_la_pena(self) }

    method cantidad_vikingos() = tripulacion.size()

    method realizarse() {
        lugares_involucrados.forEach { lugar => lugar.invadirse(self) }
    }

    method cobrarse_una_vida() {
        tripulacion.forEach { vikingo => vikingo.cobrarse_una_vida() }
    }

    method repartir_botin(unBotin) {
        const botin_proporcional = unBotin/(tripulacion.size())
        tripulacion.forEach {vikingo => vikingo.ganar_botin(botin_proporcional)}
    }
}