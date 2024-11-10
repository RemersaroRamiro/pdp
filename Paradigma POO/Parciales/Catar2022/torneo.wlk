class Torneo {

    var participantes = []
    var postres = []

    method presentar_plato(cocinero, plato) {
        participantes.add(cocinero)
        postres.add(plato)
    }

    method ganador() {
        if (not participantes.isEmpty()) {
            return participantes.get(postres.indexOf(self.mejor_postre()))
        }
        throw new Exception ( message = "Error, no hay participantes" )
    }

    method mejor_postre() = postres.max { postre => participantes.sum { participante => participante.catar_plato(postre)} }
}