import platos.*

class Pastelero {
  
    const dulzor_deseado

    method catar_plato(unPlato) = self.calificacion(unPlato).min(10)
    method calificacion(unPlato) = 5 * unPlato.cantidad_azucar() / dulzor_deseado

    method cocinar() {
        const postre = new Postre(cantidad_colores = dulzor_deseado.div(50))
        return postre
    }
}

class Chef {
  
    const calorias_deseadas = 10

    method catar_plato(unPlato) {
        if( unPlato.es_bonito() and unPlato.tiene_hasta_calorias(calorias_deseadas)){
            return 10
        }
        return self.calificacion(unPlato)
    }

    method calificacion(unPlato) = 0
    method cocinar() {
        const plato_principal = new Principal(cantidad_azucar = calorias_deseadas , esBonito = true)
        return plato_principal
    }
}

object souschef inherits Chef {
    override method calificacion(unPlato) = (unPlato.calorias() / 100).min(6)
    override method cocinar(){
        const entrada = new Entrada()
        return entrada
    }
}

