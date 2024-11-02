class Equipo {

    var grupo = []

    method alguno_puede_usar_todas(habilidades) = grupo.any { empleado => empleado.puede_usar_todas(habilidades) }

    method realizar_mision(mision) {
        mision.realizarse_por_equipo(grupo)
    }
}