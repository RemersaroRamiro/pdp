class Lugar {
    method botin()
    
    method invadirse(unaExpedicion){
        self.invadida_por(unaExpedicion)

    }

    method invadida_por(unaExpedicion) 
}

class Capital inherits Lugar {

    var defensores
    const factor_riqueza

    method vale_la_pena(unaExpedicion) = self.botin() >= 3*unaExpedicion.cantidad_vikingos()

    override method botin() = defensores * factor_riqueza

    override method invadida_por(unaExpedicion) {
        unaExpedicion.cobrarse_una_vida()
        unaExpedicion.repartir_botin(self.botin())
    }
}

class Aldea inherits Lugar{

    var crucifijos_en_iglesias

    method vale_la_pena(unaExpedicion) = self.botin() >= 15

    override method botin() = crucifijos_en_iglesias

    override method invadida_por(unaExpedicion) {
        crucifijos_en_iglesias = 0
    }
}

class Aldea_Protegida inherits Aldea {

    const cantidad_minima_necesaria

    override method vale_la_pena(unaExpedicion) = super(unaExpedicion) and unaExpedicion.tiene_minimo_de_vikingos(cantidad_minima_necesaria)  

}

