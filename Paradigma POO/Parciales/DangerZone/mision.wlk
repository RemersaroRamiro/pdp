class Mision {
    
    var habilidades_requeridas = []

    var peligrosidad

    method puede_hacerla(empleado) = empleado.puede_usar_todas(habilidades_requeridas)

    method pueden_hacerla(equipo) = equipo.any { empleado => self.puede_hacerla(empleado) } 

    method causar_danio(empleado) {
        empleado.disminuir_vida(peligrosidad)
    }

    method realizarse_por_empleado(empleado) {
        if(self.puede_hacerla(empleado)){
            self.causar_danio(empleado)
        }
    }
    
    method realizarse_por_equipo(equipo) {
        if(self.pueden_hacerla(equipo)){
            equipo.forEach{ empleado => self.causar_danio(peligrosidad/3)}
        }
    }

    method enseniar_habilidades(empleado) {
        (self.habilidades_faltantes(empleado)).forEach { habilidad => empleado.aprender_habilidad(habilidad) }
    }

    method habilidades_faltantes(empleado) = habilidades_requeridas.filter { habilidad => not empleado.tiene_habilidad(habilidad) }
}