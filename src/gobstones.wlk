import wollok.game.*

object tablero {
	
	var property cantColumnas = 5
	var property cantFilas = 5
	
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
		keyboard.num(1).onPressDo({cabezal.poner(rojo)})
		keyboard.num(2).onPressDo({cabezal.poner(verde)})
		keyboard.num(3).onPressDo({cabezal.poner(azul)})
		keyboard.num(4).onPressDo({cabezal.poner(negro)})
		keyboard.num(5).onPressDo({cabezal.sacar(rojo)})
		keyboard.num(6).onPressDo({cabezal.sacar(verde)})
		keyboard.num(7).onPressDo({cabezal.sacar(azul)})
		keyboard.num(8).onPressDo({cabezal.sacar(negro)})
		
	}
	
	method celda(columna, fila){
		return columnas.get(columna).get(fila)
	}
	
	method posicionPara(columna,fila) = 
		game.at(columna*2,fila*2)
	
	
	
}



object cabezal {
	
	
	var fila = 0
	var columna = 0
	
	method image() = "cabezal.png"
	
	method position() = tablero.posicionPara(columna,fila)
	
	method poner(color) {
		 tablero.celda(columna,fila).poner(color)
	}
	
	method sacar(color) {
		 tablero.celda(columna,fila).sacar(color)
	}
	method configurarTeclas() {
		keyboard.up().onPressDo({fila = (fila + 1).min(tablero.cantFilas()-1)})
		keyboard.down().onPressDo({fila =(fila - 1).max(0)})
		keyboard.right().onPressDo({columna = (columna + 1).min(tablero.cantColumnas()-1)})
		keyboard.left().onPressDo({columna = (columna - 1).max(0)})
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
	
	method image() = color + ".png"
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

const verde = "verde"
const rojo = "rojo"
const azul = "azul"
const negro = "negro"
