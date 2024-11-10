class Casta {
    method permite_expedicion(unVikingo) = true
    method escalar(unVikingo){}
}

object jarl inherits Casta {
    override method permite_expedicion(unVikingo) = not unVikingo.esta_armado()
    override method escalar(unVikingo) {
        unVikingo.casta(karl)
        unVikingo.ganancia_social()
    }
}

object karl inherits Casta {
    override method escalar(unVikingo) {
        unVikingo.casta(thrall)
    }
}

object thrall inherits Casta {
}   