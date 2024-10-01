//
//  ViewController.swift
//  TheBlueApp
//
//  Created by JSenen on 1/10/24.
//

import UIKit
import CoreBluetooth

// La clase ViewController implementa los protocolos CBCentralManagerDelegate y CBPeripheralDelegate
// para manejar eventos de Bluetooth, como la búsqueda de dispositivos y la conexión a ellos.
class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Propiedades:
    var centralManager: CBCentralManager!  // El objeto CBCentralManager gestiona la interacción con Bluetooth.
    var myPeripheral: CBPeripheral!        // Una referencia al periférico BLE con el que nos conectamos.
    
    // Este método se llama cuando el estado del Bluetooth cambia (por ejemplo, cuando se enciende o apaga).
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Verifica si el estado de Bluetooth está encendido
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")  // Imprime un mensaje cuando el Bluetooth está encendido.
            // Comienza a escanear periféricos BLE sin filtrar por un servicio específico.
            central.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            // Si el estado de Bluetooth no es poweredOn, imprime un mensaje de error.
            print("Something wrong with BLE")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let pname = peripheral.name {
            print("Dispositivo descubierto: \(pname)")
        } else {
            print("Dispositivo descubierto sin nombre")
        }
        
        print("RSSI: \(RSSI)")
        
        // Mostrar más información desde advertisementData
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("Nombre local: \(localName)")
        }
        
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            print("Datos del fabricante: \(manufacturerData)")
        }
        
        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            print("UUIDs de servicios: \(serviceUUIDs)")
        }
        
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] {
            print("Datos del servicio: \(serviceData)")
        }
        
        if let txPowerLevel = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber {
            print("Nivel de potencia de transmisión: \(txPowerLevel)")
        }
        
        if let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool {
            print("Conectable: \(isConnectable ? "Sí" : "No")")
        }
        
        if let solicitedServiceUUIDs = advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID] {
            print("UUIDs de servicios solicitados: \(solicitedServiceUUIDs)")
        }
    }

    
    // Este método se llama cuando se conecta a un periférico BLE.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Al conectarse a un periférico, inicia la búsqueda de servicios ofrecidos por el periférico.
        self.myPeripheral.discoverServices(nil)  // Se pasa nil para descubrir todos los servicios.
    }
    
    // El método viewDidLoad se llama una vez que la vista se ha cargado. Aquí inicializamos el CBCentralManager.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Inicializa el centralManager y configura el ViewController como su delegado para manejar eventos BLE.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}
