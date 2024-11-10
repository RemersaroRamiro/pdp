class Cocinero {

    var especialidad

    method catar_plato(unPlato) = especialidad.catar_plato(unPlato)

    method cambiar_especialidad(nuevaEspecialidad){
        especialidad = nuevaEspecialidad
    }

    method cocinar()

    method participar_torneo(torneo) {
        torneo.presentar_plato(self, self.cocinar())
    }
}