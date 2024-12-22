//
//  ChatBotViewController.swift
//  LibRaulito
//
//  Created by DAMII on 6/12/24.
//

import UIKit

struct Message {
    let text: String
    let isUser: Bool // Indica si el mensaje es del usuario o del bot
}

class ChatBotViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages: [Message] = [
           Message(text: "¡Hola! ¿En qué puedo ayudarte?Los mensajes mas sugeridos son Productos, Categorias y nuestra ubicacion", isUser: false)
       ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
            let message = messages[indexPath.row]

            // Configurar el estilo del texto
            cell.textLabel?.text = message.text
            cell.textLabel?.textAlignment = message.isUser ? .right : .left
            cell.textLabel?.textColor = message.isUser ? .blue : .black
            
            // Permitir múltiples líneas
            cell.textLabel?.numberOfLines = 0
            
            return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44 // Altura estimada inicial

                tableView.delegate = self
                tableView.dataSource = self
                
                // Registra la celda para mensajes
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let userInput = messageTextField.text, !userInput.isEmpty else { return }
                
                // Agrega el mensaje del usuario
                messages.append(Message(text: userInput, isUser: true))
                
                // Responde el chatbot
                let botResponse = generateBotResponse(to: userInput)
                messages.append(Message(text: botResponse, isUser: false))
                
                // Actualiza la tabla y limpia el campo de texto
                tableView.reloadData()
                messageTextField.text = ""
                
                // Desplázate al último mensaje
                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - Lógica del Bot
        func generateBotResponse(to message: String) -> String {
            // Lógica básica para el bot
            if message.lowercased().contains("hola") {
                return "¡Hola! ¿Cómo estás?, ¿En que te puedo ayudar?"
            } else if message.lowercased().contains("bien y tu") {
                return "Gracias por preocuparte, estoy bien. Algo mas en que te pueda ayudar"
            } else if message.lowercased().contains("productos") {
                return "Ofrecemos productos como libros y lapiceros. ¿Qué necesitas?"
            } else if message.lowercased().contains("aténcion") {
                return "Estamos atendiendo de Lunes a Sabado de las 8:00 am hasta las 5:00 pm"
            } else if message.lowercased().contains("ubicacion") {
                return "Nos ubicamos en Calle Los Laureles 337, La Esperanza 13012. ¿Tambien puedes encontrarnos en la seccion ubicacion encontrada en la perte inferior de tu pantalla?"
            } else {
                return "Lo siento, no entendí eso. ¿Puedes repetirlo?"
            }
        }
    }

    
    

