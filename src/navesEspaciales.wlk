class Nave{
	var velocidad=0
	var direccion=0
	var combustible=0
	method combustible()=combustible
	method direccion()=direccion
	method velocidad()=velocidad
	method estaTranquila()=combustible>=4000&&velocidad<12000
	method prepararViaje(){
		self.accionAdicionalEnPrepararViaje()
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method acelerar(cuanto){velocidad=100000.min(velocidad+cuanto)}
	method desacelerar(cuanto){velocidad=0.max(velocidad-cuanto)}
	method irHaciaElSol(){direccion=10}
	method escaparDelSol(){direccion=-10}
	method ponerseParaleloAlSol(){direccion=0}
	method acercarseUnPocoAlSol(){10.min(direccion+1)}
	method alejarseUnPocoDelSol(){direccion=-10.max(direccion-1)}
	method cargarCombustible(litros){combustible+=litros}
	method descargarCombustible(litros){combustible=0.max(combustible-litros)}
	method accionAdicionalEnPrepararViaje()
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	method relajo()=self.estaTranquila()&&self.pocaActividad()
	method pocaActividad()
}

class Baliza inherits Nave{
	var color
	var cambioColorBaliza =false
	method color()=color
	method cambiarColorDeBaliza(colorNuevo){
		color=colorNuevo
		cambioColorBaliza=true
	}
	override method accionAdicionalEnPrepararViaje(){
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquila()=super()&&color!="rojo"
	override method escapar(){self.irHaciaElSol()}
	override method avisar(){self.cambiarColorDeBaliza("rojo")}
	override method pocaActividad() = not cambioColorBaliza
}

class Pasajero inherits Nave{
	var comida
	var bebida
	var cantPasajeros
	var cantDeComidaServida=0
	method cantPasajeros()=cantPasajeros
	method comida()=comida
	method bebida()=bebida
	
	method cargarBebida(unaCantidad){bebida+=unaCantidad}
	method cargarComida(unaCantidad){comida+=unaCantidad}
	method descargarComida(unaCantidad){comida=0.max(comida-unaCantidad) cantDeComidaServida+=unaCantidad}
	method descargarBebida(unaCantidad){bebida=0.max(bebida-unaCantidad)}
	override method accionAdicionalEnPrepararViaje(){
		self.cargarComida(cantPasajeros*4)
		self.cargarBebida(cantPasajeros*6)
		self.acercarseUnPocoAlSol()
	}
	override method escapar(){velocidad=velocidad*2}
	override method avisar(){self.descargarComida(cantPasajeros) self.descargarBebida(cantPasajeros*2)}
	override method pocaActividad() = cantDeComidaServida<50
}

class Combate inherits Nave{
	var misilesDesplegados=false
	var estaInvisible=true
	const mensajes=[]
	method ponerseVisible(){estaInvisible=false}
	method ponerseInvisible(){estaInvisible=true}
	method estaInvisible()=estaInvisible
	
	method desplegarMisiles(){misilesDesplegados=true}
	method replegarMisiles(){misilesDesplegados=false}
	method misilesDesplegados()=misilesDesplegados

	method mensaje()=mensajes
	method emitirMensaje(mensaje){mensajes.add(mensaje)}
	method mensajesEmitidos()= mensajes.size()
	method primerMensajeEmitido(){ if(mensajes.isEmpty())self.error("No hay mensajes") return mensajes.first()}
	method ultimoMensajeEmitido(){ if(mensajes.isEmpty())self.error("No hay mensajes") return mensajes.last()}
	method esEscueta()=mensajes.all({mensaje=>mensajes.size()<=30})
	method esEscueta1()= not mensajes.any({mensaje=>mensaje.size()>30})
	method emitioMensaje(mensaje)= mensajes.contains(mensaje)
	
	override method accionAdicionalEnPrepararViaje(){
		self.ponerseVisible()
		self.replegarMisiles()
		self.emitirMensaje("Saliendo en misión")
		self.acelerar(15000)
	}
	override method estaTranquila()= super()&&!misilesDesplegados
	
	override method escapar(){self.acercarseUnPocoAlSol() self.acercarseUnPocoAlSol()}
	override method avisar(){self.emitirMensaje("Amenaza recibida")}
	
	override method pocaActividad() = self.esEscueta()
}

class Hospital inherits Pasajero{
	var property quirofanosPreparados=false
	override method estaTranquila()= super()&&!quirofanosPreparados
	override method recibirAmenaza(){super() self.prepararQuirofanos()}
	method prepararQuirofanos(){quirofanosPreparados=true}
}

class Sigilosa inherits Combate{
	override method estaTranquila()= super()&&!estaInvisible
	override method recibirAmenaza(){super() self.desplegarMisiles() self.ponerseInvisible()}
}








