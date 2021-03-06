//Jorge Espinosa Campello
import Glibc
let π = M_PI

//////////////////
///Ejercicio 1///
/////////////////
func rand(n: Int) -> Int {
  return random() % n
}
enum MarcaCoche: Int {
  case Mercedes=0, Ferrari, RedBull, McLaren

  static func random() -> MarcaCoche {
    let valorMax = McLaren.rawValue
    let r = rand(valorMax+1)
    return MarcaCoche(rawValue: r)!
  }
}

enum TipoCambio: Int {
  case Automatico=0, Manual

  static func random() -> TipoCambio {
    let valorMax = Manual.rawValue
    let r = rand(valorMax+1)
    return TipoCambio(rawValue: r)!
  }
}

class Coche {
  var velocidadActual: Double = 0.0
  var marcha: Int = 0
  var distanciaRecorrida: Double = 0.0
  var marca: MarcaCoche = MarcaCoche.random()
  var descripcion: String {
    get {
      switch marca {
        case .Mercedes: return "Mercedes"
        case .Ferrari: return "Ferrari"
        case .RedBull: return "RedBull"
        case .McLaren: return "McLaren"
      }
    }
  }
  let velocidadMaxima: Double = 150.0
  let marchaMaxima: Int = 6

  static func random() -> Coche{
    let valorMax = 2  //Numero de subtipos de la clase cocheAutomatico
    let r = rand(valorMax)
    if(r == 0) {
      return cocheAutomatico()
    } else {
      return cocheManual()
    }
  }
}

class cocheAutomatico: Coche {
  override var velocidadActual: Double {
    didSet {
      marcha = min(Int(velocidadActual / 25.0) + 1, 5)
      distanciaRecorrida = distanciaRecorrida + velocidadActual
      print(" \(descripcion) viajando a \(velocidadActual) kilometros por hora con la marcha \(marcha)")
    }
  }

  override var descripcion: String {
    switch marca {
      case .Mercedes: return "Mercedes Automatico"
      case .Ferrari: return "Ferrari Automatico"
      case .RedBull: return "RedBull Automatico"
      case .McLaren: return "McLaren Automatico"
    }
  }
}

class cocheManual: Coche {
  override var marcha: Int {
    didSet {
      velocidadActual = 25.0 * Double(marcha)
    }
  }

  override var velocidadActual: Double {
    didSet {
      distanciaRecorrida = distanciaRecorrida + velocidadActual
      print(" \(descripcion) viajando a \(velocidadActual) kilometros por hora con la marcha \(marcha)")
    }
  }

  override var descripcion: String {
    switch marca {
      case .Mercedes: return "Mercedes Manual"
      case .Ferrari: return "Ferrari Manual"
      case .RedBull: return "RedBull Manual"
      case .McLaren: return "McLaren Manual"
    }
  }
}

class Carrera {
  let numCoches: Int
  let horas: Int
  var cochesEnCarrera: [Coche]
  init(numCoches: Int, horas: Int) {
    self.numCoches = numCoches
    self.horas = horas
    cochesEnCarrera = [Coche.random()]  //se inicializa el array con el primer coche y se añaden los siguientes
    for _ in 2...numCoches {
      cochesEnCarrera.append(Coche.random())
    }
  }

  func descripcion() {
    print(" \(numCoches) coches con una duración de \(horas) horas")
    for coche in cochesEnCarrera {
      print(" \(coche.descripcion)")
    }
  }

  func empezar() {
    for hora in 1...horas {
      print(" \nHoras transcurridas \(hora)")
      for coche in cochesEnCarrera {
        if coche is cocheAutomatico {
          coche.velocidadActual = Double(rand(Int(coche.velocidadMaxima)))
        } else if coche is cocheManual {
          coche.marcha = rand(coche.marchaMaxima)
        }
      }
    }
  }

  func clasificacion() {
    cochesEnCarrera.sortInPlace({ (a: Coche, b: Coche) -> Bool in
                          return a.distanciaRecorrida>b.distanciaRecorrida})
    for (index, coche) in cochesEnCarrera.enumerate() {
      print("\(index + 1). \(coche.descripcion) (\(coche.distanciaRecorrida) kilometros recorridos)")
    }
  }
}
print("Ejercicio 1")
let carrera = Carrera(numCoches: 2, horas: 3)
print("\nDescripción de la carrera: ")
carrera.descripcion()
print("\n!!! Comienza la carrera !!!")
carrera.empezar()
print("\n !!! Clasificacion !!!")
carrera.clasificacion()

//////////////////////////////////////////
///Ejercicio 3 (redefinición de tipos)///
////////////////////////////////////////

//Para el círculo supongo que el tamaño será igual a ancho=diámetro y alto=radio
protocol Figura {
  var centro: Punto {get set}
  var area: Double { get }
  var tamaño: Tamaño { get }
}

//////////////////
///Ejercicio 2///
/////////////////

struct Punto {
  var x = 0.0, y = 0.0
}
func == (puntoiz: Punto, puntode: Punto) -> Bool {
  return puntoiz.x==puntode.x && puntoiz.y==puntode.y
}
func != (puntoiz: Punto, puntode: Punto) -> Bool {
  return !(puntoiz==puntode)
}


struct Tamaño {
  var ancho = 0.0, alto = 0.0
}
func == (izquierdo: Tamaño, derecho: Tamaño) -> Bool {
  return izquierdo.ancho==derecho.ancho && izquierdo.alto==derecho.alto
}
func != (izquierdo: Tamaño, derecho: Tamaño) -> Bool {
  return !(izquierdo==derecho)
}

class Rectangulo: Figura {
  var origen: Punto = Punto()   //Esquina inferior izq del rectángulo
  var tamaño: Tamaño = Tamaño()  //Dimensiones del rectángulo
  var centro: Punto {
    get {
      let centroX = origen.x + (tamaño.ancho / 2)
      let centroY = origen.y + (tamaño.alto / 2)
      return Punto(x: centroX, y: centroY)
    }
    set(nuevoCentro) {
      origen.x = nuevoCentro.x - (tamaño.ancho / 2)
      origen.y = nuevoCentro.y - (tamaño.alto / 2)
    }
  }
  var area: Double {
    get {
      return tamaño.ancho * tamaño.alto
    }
  }
  init(origen: Punto, tamaño: Tamaño) {
    self.origen = origen
    self.tamaño = tamaño
  }
  func descripcion() -> String{
    return "Rectángulo con origen en \(origen), centro en \(centro) de \(tamaño) cuya area es \(area)"
  }
}
func == (izquierdo: Rectangulo, derecho: Rectangulo) -> Bool {
  return izquierdo.origen==derecho.origen && izquierdo.tamaño==derecho.tamaño && derecho.centro==izquierdo.centro && izquierdo.area==derecho.area
}
func != (izquierdo: Rectangulo, derecho: Rectangulo) -> Bool {
  return !(izquierdo==derecho)
}

print("\n\nEjercicio 2")
print("[Pruebas de un rectángulo]: creamos un rectángulo posicionado en (2,3) de tamaño 3x2m")
let rectanguloPrueba = Rectangulo(origen: Punto(x: 2, y: 3), tamaño: Tamaño(ancho: 3, alto: 2))
print("   El centro del rectángulo está situado en \(rectanguloPrueba.centro)")
print("   El área del rectángulo es \(rectanguloPrueba.area)")
print("   Cambio del centro del rectángulo a la posición (0,0)")
rectanguloPrueba.centro = Punto(x: 0, y: 0)
print("   El origen del rectángulo es \(rectanguloPrueba.origen), el tamaño del rectángulo es \(rectanguloPrueba.tamaño), el centro es \(rectanguloPrueba.centro) y el área es \(rectanguloPrueba.area)")

class Circulo: Figura {
  var centro: Punto = Punto()
  var radio: Double = 0.0
  var tamaño: Tamaño
  var area: Double {
    get {
      return π * pow(radio, 2)
    }
    set(nuevaArea) {
      radio = sqrt(nuevaArea/π)
      tamaño = Tamaño(ancho: radio * 2, alto: radio)  //suponiendo el ancho el diametro y el alto el radio
    }
  }
  init(centro: Punto, radio: Double) {
    self.centro = centro
    self.radio = radio
    tamaño = Tamaño(ancho: radio * 2, alto: radio)
  }
  func descripcion() -> String {
    return "Círculo con centro en \(centro), de radio \(radio), area \(area) y \(tamaño)"
  }
}
func == (izquierdo: Circulo, derecho: Circulo) -> Bool {
  return izquierdo.centro==derecho.centro && izquierdo.radio==derecho.radio && izquierdo.tamaño==derecho.tamaño && izquierdo.area==derecho.area
}
func != (izquierdo: Circulo, derecho: Circulo) -> Bool {
  return !(izquierdo==derecho)
}

print("[Pruebas de un circulo]: creamos un circulo en (0,0) con un radio 2")
let circulito = Circulo(centro: Punto(), radio: 2)
print("   El área del círculo es \(circulito.area)")
circulito.area = 40
print("   Cambio del área del círculo a 40m: el nuevo radio es \(circulito.radio) con centro en \(circulito.centro)")

class Triangulo: Figura {
  var p1: Punto, p2: Punto, p3: Punto
  var tamaño = Tamaño()
  var centro: Punto {
    get {
      //Ecuación del nuevo punto x=(Ax + Bx + Cx)/3 = resultado x=(Ay + By + Cy)/3 = resultado
      return Punto(x: (p1.x + p2.x + p3.x)/3, y: (p1.y + p2.y + p3.y)/3)
    }
    //Se calculan las distancias entre el centro y el primer punto y se construye el nuevo Triangulo
    //a partir del 1 punto habiendo calculado las distancias desde el primer punto hasta el 2 y el 3
    set(nuevoCentro) {
      //Distancias entre los puntos
      let distCentro1 = Punto(x: (centro.x - p1.x), y: (centro.y - p1.y))
      let dist12 = Punto(x: p2.x-p1.x, y: p2.y-p1.y)
      let dist13 = Punto(x: p3.x-p1.x, y: p3.y-p1.y)
      p1 = Punto(x: nuevoCentro.x-distCentro1.x, y: nuevoCentro.y-distCentro1.y)
      p2 = Punto(x: p1.x+dist12.x, y: p1.y+dist12.y)
      p3 = Punto(x: p1.x+dist13.x, y: p1.y+dist13.y)
      tamaño = Tamaño(ancho: max(p1.x, p2.x, p3.x), alto: min(p1.y, p2.y, p3.y))
    }
  }
  var area: Double {
    get {
      let base = p2.x-p1.x
      let altura = p3.y-p1.y
      return (base * altura)/2
    }
  }
  init(p1: Punto, p2: Punto, p3: Punto) {
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
  }
  func descripcion() -> String {
    return "Triángulo formado por los puntos \(p1), \(p2) y \(p3), con centro en el \(centro), area \(area) y tamaño \(tamaño)"
  }
}
func == (izquierdo: Triangulo, derecho: Triangulo) -> Bool {
  return izquierdo.p1==derecho.p1 && izquierdo.p2==derecho.p2 && izquierdo.p3==derecho.p3 && izquierdo.tamaño==derecho.tamaño && izquierdo.centro==derecho.centro
}
func != (izquierdo: Triangulo, derecho: Triangulo) -> Bool {
  return !(izquierdo==derecho)
}

print("[Pruebas de un triangulo]: creamos un triángulo en (0,0), (2,0), (1,3) ")
let triangulo = Triangulo(p1: Punto(), p2: Punto(x: 2, y:0), p3: Punto(x:1, y:3))
print("   El centro del triángulo es \(triangulo.centro), el area = \(triangulo.area); ahora lo cambiamos al punto (2,2)")
triangulo.centro = Punto(x: 2, y: 2)
print("   Las nuevas posiciones del triángulo son [\(triangulo.p1), \(triangulo.p2), \(triangulo.p3)] y el area = \(triangulo.area)")
triangulo.centro = Punto(x: 6, y:7)
print("   Volvemos a cambiar la posición del centro al punto (6,7) y el resultado es [\(triangulo.p1), \(triangulo.p2), \(triangulo.p3)] y el area = \(triangulo.area)")

/////////////////////////////////
///Ejercicio 3 (continuación)///
///////////////////////////////
func cuentaTipos(figuras: [Figura]) -> (Int, Int, Int) {
  var resultado: (Int, Int, Int) = (0, 0, 0)
  for (index, item) in figuras.enumerate() {
    switch item {
      case is Rectangulo:
        let rectangulo = item as! Rectangulo  //Se utiliza as! porque al haber comprobado previamente que el tipo del item sería rectángulo se puede asegurar el tipo
        print(" \(index+1). " + rectangulo.descripcion())
        resultado.0 += 1
      case is Circulo:
        let circulo = item as! Circulo
        print(" \(index+1). " + circulo.descripcion())
        resultado.1 += 1
      case is Triangulo:
        let triangulo = item as! Triangulo
        print(" \(index+1). " + triangulo.descripcion())
        resultado.2 += 1
      default: print("  Error, figura no definida")
    }
  }
  return resultado
}
print("Ejercicio 3")
print(" Definición de 6 figuras distintas...")
//Se utilizarán 3 figuras creadas para la realización de las pruebas del ejercicio 2
let rectangulo2 = Rectangulo(origen: Punto(), tamaño: Tamaño(ancho: 10, alto: 1))
let circulo2 = Circulo(centro: Punto(), radio: 23)
let triangulo2 = Triangulo(p1: Punto(), p2: Punto(x: 2, y:0), p3: Punto(x:1, y:3))
let arrayFiguras: [Figura] = [rectanguloPrueba, circulito, triangulo, rectangulo2, circulo2, triangulo2]
print(" Contamos los tipos del array con las 6 figuras: ")
print(" \(cuentaTipos(arrayFiguras))")
