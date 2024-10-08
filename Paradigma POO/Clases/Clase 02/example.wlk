object pepe {
  var property antiguedad = 1
  var property faltas = 0
  var puesto = desarrollador
  var bono_faltas = nulo
  var bono_resultado = fijo

  method sueldo() {
    return self.sueldo_neto() + self.bono_presentismo() + self.bono_por_empresa()
  }
  method sueldo_neto() {
    return puesto.sueldo_neto(self)
  }
  method bono_presentismo() {
    return bono_faltas.bono(self)
  }
  method bono_por_empresa() {
    return bono_resultado.bono(self)
  }

  // Setters solo para PRUEBAS
  method puesto(nuevo_puesto) {
    puesto = nuevo_puesto
  }
  method bono_faltas(nuevo_bono) {
    bono_faltas = nuevo_bono
  }
  method bono_resultado(nuevo_bono) {
    bono_resultado = nuevo_bono
  }
}

object manager {
  method sueldo_neto(empleado) {
    return 1500 + 50 * empleado.antiguedad()
  }
}
object desarrollador {
  method sueldo_neto(empleado) {
    return 1000 + 25 * empleado.antiguedad()
  }
}
object gerente {
  method sueldo_neto(empleado) {
    return 2500 + 100 * empleado.antiguedad()
  }
}

object nulo {
  method bono(empleado){
    return 0
  }
}

object por_faltas{
  method bono(empleado){
    if (empleado.faltas() == 0){
      return 100
    } else if (empleado.faltas() == 1){
      return 50 - empleado.antiguedad()
    } else {
      return 0
    }
  }
}

object nioqui {
  method bono(empleado){
    return 2 ** empleado.faltas()
  }
}

object sti {
  method bono(empleado) {
    return (pepe.sueldo_neto()/100) * 25 
  }
}

object fijo {
  method bono(empleado) {
    return 15 + empleado.antiguedad()
  }
}

object ninguno {
  method bono(empleado) {
    return 0
  }
}