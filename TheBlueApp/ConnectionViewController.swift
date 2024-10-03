//
//  ConnectionViewController.swift
//  TheBlueApp
//
//  Created by JSenen on 2/10/24.
//
import UIKit
import CoreBluetooth

class ConnectionViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth está encendido y listo.")
            
        case .poweredOff:
            statusLabel.text = "Bluetooth está apagado. Por favor, enciéndelo."
            print("Bluetooth está apagado.")
        case .resetting:
            statusLabel.text = "Bluetooth se está reiniciando."
            print("Bluetooth se está reiniciando.")
        case .unauthorized:
            statusLabel.text = "Bluetooth no está autorizado para esta app."
            print("Bluetooth no autorizado.")
        case .unsupported:
            statusLabel.text = "Este dispositivo no soporta Bluetooth."
            print("Bluetooth no soportado en este dispositivo.")
        case .unknown:
            statusLabel.text = "Estado desconocido de Bluetooth."
            print("Estado desconocido.")
        @unknown default:
            statusLabel.text = "Error desconocido de Bluetooth."
            print("Error desconocido.")
        }
    }


    var peripheral: CBPeripheral?
    var centralManager: CBCentralManager?

    @IBOutlet weak var statusLabel: UILabel!  // Muestra el estado de la conexión

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Conect Screen"
        
        configureItems()
        
        
        // Verificar que el periférico esté configurado
        guard let peripheral = peripheral else { return }
        print("Dispositivo pasado a ConnectionView: \(peripheral)")

        // Establecer el delegado para el centralManager
        centralManager?.delegate = self
        
        // Iniciar la conexión y actualizar el estado
        statusLabel.text = "Intentando conectar a \(peripheral.name ?? "dispositivo")..."
        
        peripheral.delegate = self
        centralManager?.connect(peripheral, options: nil)
    }
    
    private func configureItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: nil)
        
    }


    // Método delegado de CBCentralManager: se llama cuando la conexión tiene éxito
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Conectado a \(peripheral.name ?? "dispositivo")")
        statusLabel.text = "Conectado a \(peripheral.name ?? "dispositivo")"
        peripheral.discoverServices(nil)  // Comenzar a descubrir servicios si es necesario
    }
    
    // Método delegado de CBCentralManager: se llama si la conexión falla
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Error al conectar: \(error?.localizedDescription ?? "desconocido")")
        statusLabel.text = "Error al conectar: \(error?.localizedDescription ?? "desconocido")"
    }

    // Métodos de delegado CBPeripheral para manejar servicios/características
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error al descubrir servicios: \(error.localizedDescription)")
            return
        }
        
        // Mostrar los servicios descubiertos
        if let services = peripheral.services {
            for service in services {
                print("Servicio encontrado: \(service.uuid)")
            }
        }
    }
    
    
}
