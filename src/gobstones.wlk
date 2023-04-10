import wollok.game.*





object tablero {
	
	var property cantColumnas = 4
	var property cantFilas = 4
	
	const columnas = []
	
	method iniciar(){
		
		game.width(cantColumnas*2)
		game.height(cantFilas*2)
		
		game.title("Wollokstones")
		
		game.addVisual(cabezal)
		
		self.configurarTeclas()
		
		self.crearCeldas()
		cabezal.configurarTeclas()
	
	}
	method crearCeldas(){
		cantColumnas.times({c=>
			columnas.add([])
			cantFilas.times({f=>
				columnas.last().add(new Celda(columna = c-1, fila = f-1 ))
				
			})
		})
	}

	method configurarTeclas() {
		keyboard.num(1).onPressDo({rojo.poner()})
		keyboard.num(2).onPressDo({rojo.sacar()})
		keyboard.num(3).onPressDo({verde.poner()})
		keyboard.num(4).onPressDo({verde.sacar()})
		keyboard.num(5).onPressDo({azul.poner()})
		keyboard.num(6).onPressDo({azul.sacar()})
		keyboard.num(7).onPressDo({negro.poner()})
		keyboard.num(8).onPressDo({negro.sacar()})
		
	}
	
	method celda(columna, fila){
		return columnas.get(columna).get(fila)
	}
	
	method posicionPara(columna,fila) = 
		game.at(columna*2,fila*2)
	
	
	
}



object cabezal {
	
	
	var property fila = 0
	var property columna = 0
	
	method image() = "cabezal.png"
	
	method position() = tablero.posicionPara(columna,fila)
	
	method poner(color) {
		 tablero.celda(columna,fila).poner(color)
	}
	
	method sacar(color) {
		 tablero.celda(columna,fila).sacar(color)
	}
	method configurarTeclas() {
		keyboard.up().onPressDo({self.mover(norte)})
		keyboard.down().onPressDo({self.mover(sur)})
		keyboard.right().onPressDo({self.mover(este)})
		keyboard.left().onPressDo({self.mover(oeste)})
	}
	
	method mover(direccion) {
		direccion.mover()
	}
	method fila(nuevaFila){ 
		fila = nuevaFila.min(tablero.cantFilas()-1).max(0)
	}
	method columna(nuevaColumna){
		columna = nuevaColumna.min(tablero.cantColumnas()-1).max(0)
	}
}

object este {
	method mover(){
		cabezal.columna(cabezal.columna()+1)
	}
}
object oeste {
	method mover(){
		cabezal.columna(cabezal.columna()-1)
	}
}
object norte {
	method mover(){
		cabezal.fila(cabezal.fila()+1)
	}
}
object sur {
	method mover(){
		cabezal.fila(cabezal.fila()-1)
	}
}

class Celda {
	
	const fila
	const columna
	
	const bolitas = new Dictionary()
	
	method initialize(){
		bolitas.put(rojo,new Bolitas(
			color = rojo,
			cantidad = 0,
			position = tablero.posicionPara(columna,fila)
		))
		bolitas.put(verde,new Bolitas(
			color = verde,
			position = tablero.posicionPara(columna,fila).right(1)
		))
		bolitas.put(azul,new Bolitas(
			color = azul,
			position = tablero.posicionPara(columna,fila).up(1)
		))
		bolitas.put(negro,new Bolitas(
			color = negro,
			position = tablero.posicionPara(columna,fila).right(1).up(1)
		))
	}
	
	method poner(color) {
		bolitas.get(color).poner()
	}
	method sacar(color) {
		bolitas.get(color).sacar()
	}
}


class Bolitas {
	
	var cantidad = 0
	var color
	var property position
	
	method image() = color.nombre() + ".png"
	method text() = cantidad.toString()
	
	method poner() {
		cantidad += 1
		if (cantidad == 1)
			game.addVisual(self)
		
	}
	
	method sacar() {
		cantidad -=1
		if(cantidad == 0)
			game.removeVisual(self)
	}
	
	method cantidad() = cantidad
}


class Color{ 
	var property nombre

	method poner(){
		cabezal.poner(self)
	}
	method sacar(){
		cabezal.sacar(self)
	}
}

const verde = new Color(nombre = "verde")
const rojo = new Color(nombre = "rojo")
const azul = new Color(nombre = "azul")
const negro = new Color(nombre = "negro")

