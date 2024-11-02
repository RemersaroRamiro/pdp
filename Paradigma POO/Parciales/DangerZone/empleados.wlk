class Empleado {

    var salud = 100
    var puesto_trabajo
    var habilidades = #{}

    method esta_incapacitado() = salud < puesto_trabajo.salud_critica() 

    method puede_usar_habilidad(habilidad) = not self.esta_incapacitado() and self.tiene_habilidad(habilidad)
    method tiene_habilidad(habilidad) = habilidades.contains(habilidad)
    method puede_usar_todas(habilidades_requeridas) = habilidades_requeridas.forEach { habilidad => self.puede_usar_habilidad(habilidad) } 

    method cumplir_mision(mision) {
        mision.realizarse(self)
        if(self.sobrevive()){
            puesto_trabajo.registrar(mision, self)
        }
    }   

    method sobrevive() = salud > 0
    method disminuir_salud(cantidad) {
        salud -= cantidad
    }

    method puesto_trabajo(nuevo_puesto) {
        puesto_trabajo = nuevo_puesto
    }

    method aprender_habilidad(habilidad) {
        habilidades.add(habilidad)
    }
}

object espia {
    method salud_critica() = 15

    method registrar(mision, empleado) {
        mision.enseniar_habilidades(empleado)
    }
}

class Oficinista {
    var estrellas = 0
    method salud_critica() = 40 - 5 * estrellas

    method registrar(mision, empleado) {
        self.aumentar_estrellas()
        if(estrellas == 3){
            empleado.puesto_trabajo(espia)
        }
    }
    method aumentar_estrellas(){
        estrellas += 1
    }
} 

class Jefe inherits Empleado {

    var empleados = []

    override method tiene_habilidad(habilidad) = super(habilidad) || self.algun_empleado_la_puede_usar(habilidad)
    method algun_empleado_la_puede_usar(habilidad) = empleados.any { empleado => empleado.puede_usar_habilidad(habilidad) }
}