class Vikingo {

    var casta
    var oro

    method subir_expedicion(unaExpedicion) {
        self.verificar_capacidad_para_expedicion()
        unaExpedicion.subir_a(self)
    }

    method verificar_capacidad_para_expedicion() {
        if (not self.puede_subir_expedicion()){
            throw new Exception ( message = "Error, el vikingo no puede subir a una expedicion" )
        }
    }

    method puede_subir_expedicion() = self.es_productivo() and self.casta_lo_permite()

    method es_productivo()

    method casta_lo_permite() = casta.permite_expedicion(self)

    method ganar_botin(unBotin) {
        self.aumentar_oro(unBotin)
    }

    method aumentar_oro(cantidad) {
        oro += cantidad
    }

    method cobrarse_una_vida() {}
/*
Como sabemos, los vikingos tienen una gran organización social que les permite ascender en la escala social. Los Jarl (esclavos) pueden convertirse en Karl (casta media) y 
en ese momento ganan 10 armas en el caso de ser soldados, y 2 hijos y 2 hectáreas en caso de ser granjeros. Los Karl se convierten en Thrall (nobles), pero los Thrall no 
escalan más.
*/
    method ascender_socialmente() {
        casta.escalar(self)
    }

    method ganancia_social()

    method casta(nuevaCasta) {
        casta = nuevaCasta
    }
    method casta() = casta
}