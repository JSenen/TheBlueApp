import UIKit
import CoreBluetooth

// Asegúrate de que el ViewController ahora sea el delegado y datasource de UITableView
class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!  // Conexión de la tabla en el Storyboard
    
    
    var centralManager: CBCentralManager!       // Manejador central del Bluetooth
    var peripherals: [(peripheral: CBPeripheral, rssi: NSNumber)] = []  // Lista de periféricos descubiertos con su RSSI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registrar una celda reutilizable con el identificador "PeripheralCell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PeripheralCell")
        
        // Configurar delegado y datasource de la UITableView
        tableView.delegate = self
        tableView.dataSource = self
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    
    // Método requerido para UITableViewDataSource: número de filas en la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Número de filas: \(peripherals.count)")
        return peripherals.count  // El número de dispositivos descubiertos
    }
    
    // Método requerido para UITableViewDataSource: configuración de la celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configurando celda para fila \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell", for: indexPath)
        
        let peripheral = peripherals[indexPath.row].peripheral
        let rssi = peripherals[indexPath.row].rssi
        
        // Mostrar solo los periféricos con nombre
            if let peripheralName = peripheral.name {
                cell.textLabel?.text = peripheralName
                cell.detailTextLabel?.text = "RSSI: \(rssi)"
            } else {
                // Si no tiene nombre, no mostrar nada en la celda
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
            
            return cell
    }
    
    // Método requerido para actualizar el estado de Bluetooth
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")
            central.scanForPeripherals(withServices: nil, options: nil)  // Comenzar escaneo
        } else {
            print("Something wrong with BLE")
        }
    }
    
    // Método para manejar dispositivos descubiertos
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Solo añadir los dispositivos que tienen un nombre
        if let pname = peripheral.name {
            print("Dispositivo descubierto: \(pname)")
            
            // Añadir los dispositivos descubiertos a la lista si no están ya incluidos
            if !peripherals.contains(where: { $0.peripheral.identifier == peripheral.identifier }) {
                peripherals.append((peripheral: peripheral, rssi: RSSI))
                
                // Actualizar la tabla en el hilo principal
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    

}
